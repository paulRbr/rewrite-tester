require 'rewrite_rule'

class Redirects

  def initialize(io_instance, http_host = 'example.com')
    @rules = []

    unless io_instance.nil?
      io_instance.readlines.each do |line|
        @rules << RewriteRule.new(line, http_host)
      end
    end
  end
  
  attr_accessor :rules

end
