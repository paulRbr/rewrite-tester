require 'invalid_rule'

class RewriteCond 
  def initialize(line)
    @line = line
    self.parse line

    raise InvalidRule.new unless valid?
  end

  def parse(line)
    match_data = /RewriteCond[ ]+([^ ]+)[ ]+([^ ]+)([ ]+\[([^ ]+)\]\n?)?$/.match(line)

    return if match_data.nil?

    @expression = match_data[1]
    @compare = match_data[2]
    @flags = match_data[4].nil? ? nil : match_data[4].split(',')
  end

  def valid?
    !@expression.nil? && !@compare.nil?
  end

end
