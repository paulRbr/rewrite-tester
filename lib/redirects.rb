require 'rewrite_rule'
require 'rewrite_cond'

class Redirects

  HTTP_HOST = ENV['HTTP_HOST'] || 'example.com'
  HTTP_SCHEME = ENV['HTTP_SCHEME'] || 'http://'

  def initialize(io_instance)
    @rules = []
    @untestable_rules = []
    unless io_instance.nil?

      conds = []

      io_instance.readlines.each.with_index do |line,i|

        begin
          match_data = /^[^#]*RewriteCond/.match(line)

          unless match_data.nil?
            conds << RewriteCond.new(line)
            next
          end

          match_data = /^[^#]*RewriteRule/.match(line)

          unless match_data.nil?
            rule = RewriteRule.new(line, conds)
            @rules << rule
            conds = []
            next
          end
        rescue InvalidRule => e
          raise "\e[41mSyntax error on Line #{i+1}: #{line}\e[49m"
        rescue Untestable => e
          @untestable_rules << "(Line #{i+1}) #{/.*(Rewrite.*)/.match(line)[1]}"
        end

      end

      unless @untestable_rules.empty?
        text = <<EOS
\e[91m
Rewriting rule with conditions are not supported (for now..), please check the following rules by hand:
#{@untestable_rules.join("\n")}
\e[49m
EOS
        puts text
      end
    end
  end
  
  attr_accessor :rules, :http_host, :http_scheme

  def self.substitute substitute_rule, substituted_data = []
    return nil if substitute_rule == '-'
    substitution = substitute_rule
    substitution = "/#{substitution}" if /^(\/|https?:\/\/)/.match(substitution).nil?
    substitution = "#{HTTP_SCHEME}#{HTTP_HOST}#{substitution}" unless /^https?\:\/\//.match(substitution)
    substitution = substitution.
      gsub(/\$[0-9]+?/){ |m| !m.nil? && substituted_data[m[1..-1].to_i-1] || '' }.
      gsub('%{HTTP_HOST}', HTTP_HOST).
      gsub('%{HTTP_SCHEME}', HTTP_SCHEME)
  end

end
