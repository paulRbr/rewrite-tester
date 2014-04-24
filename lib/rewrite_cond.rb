class RewriteCond 
  def initialize(line)
    @line = line
    self.parse line
  end

  def parse(line)
    match_data = /RewriteCond[ ]+([^ ]+)[ ]+([^ ]+)([ ]+\[([^ ]+)\]\n?)?$/.match(line)

    return if match_data.nil?

    @expression = match_data[1]
    @compare = match_data[2]
    @flgas = match_data[3]
  end

end
