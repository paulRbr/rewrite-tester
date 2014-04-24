require 'rewrite_rule'
require 'rewrite_cond'

class Redirects

  HTTP_HOST = ENV['HTTP_HOST'] || 'example.com'
  HTTP_SCHEME = ENV['HTTP_SCHEME'] || 'http://'

  def initialize(io_instance)
    @rules = []
    unless io_instance.nil?

      conds = []

      io_instance.readlines.each do |line|

        match_data = /RewriteCond/.match(line)

        unless match_data.nil?
          conds << RewriteCond.new(line)
          next
        end

        match_data = /RewriteRule/.match(line)

        unless match_data.nil?
          @rules << RewriteRule.new(line, conds)
          conds = []
          next
        end
      end
    end
  end
  
  attr_accessor :rules, :http_host, :http_scheme

  def self.substitute substitute_rule, substituted_data = []
    substitution = substitute_rule
    substitution = "#{HTTP_SCHEME}#{HTTP_HOST}#{substitution}" unless /^https?\:\/\//.match(substitution)
    substitution = substitution.
      gsub(/\$[0-9]+?/){ |m| !m.nil? && substituted_data[m[1..-1].to_i-1] || '' }.
      gsub('%{HTTP_HOST}', HTTP_HOST).
      gsub('%{HTTP_SCHEME}', HTTP_SCHEME)
  end

end
