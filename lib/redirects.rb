require 'rewrite_rule'

class Redirects

  def initialize io_instance
    @rules = []

    unless io_instance.nil?
      io_instance.readlines.each do |line|
        @rules << RewriteRule.new(line)
      end
    end
  end

  # Increments the rul reading
  def has_next?
    !@rules.empty?
  end

  # Returns a rule
  def next
    @rules.pop
  end

  attr_accessor :rules

end