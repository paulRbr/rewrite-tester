class RewriteRule

  attr_accessor :possibilities, :substitution, :line

  def initialize(line, http_host = 'example.com', http_scheme = 'http://')
    @line = line
    @http_host = http_host
    @http_scheme = http_scheme
    self.parse line
  end

  # Parse an apache RewriteRule and transform it into a Ruby object
  def parse(line)

    match_data = /RewriteRule ([^ ]+) ([^ ]+) \[([^ ]+)\](\n)?$/.match(line)

    return if match_data.nil?

    me = self

    @regex = match_data[1]
    @possibilities = generate_possibilities @regex
    @substitution = match_data[2]
    @substitutions = @possibilities.map do |possibility|
      me.send(:substitute, @substitution, possibility[:substituted_data])
    end
    @flags = match_data[3].split(',')

  end

  def valid?
    !@regex.nil? && !@substitution.nil? && !@flags.nil?
  end

  def redirection?
    !@flags.nil? && @flags.any?{ |flag| /^R/.match(flag) }
  end

  def redirects
    me = self
    
    @substitutions.map.with_index do |substitution, i|
      { 
        :possibility => me.send(:substitute, @possibilities[i][:request_uri]),
        :substitution => substitution, 
        :code => redirection_code(@flags)
      }
    end
  end

  private

  def generate_possibilities regex
    some = []
    base = regex.gsub(/\^|\$/,'')

    # Maybe will generate two possibilities, with and without
    maybe_regex = /\(([^)^(]+?)\)\??/
    match_data = maybe_regex.match(base)
    substituted_data = []
    until match_data.nil?    
      matched = match_data[1]
      if /\.\*/.match(matched)
        matched = match_data[0].gsub('.*', generate_random_string(0, 8))
      elsif /\?$/.match(match_data[0])            
        matched = rand(2) == 0 ? match_data[1] : ''
      end
      
      base = base.gsub(match_data[0], matched)
      substituted_data << matched
      match_data = maybe_regex.match(base) 
    end
    
    some << {
      :request_uri => "#{base}",
      :substituted_data => substituted_data
    }
  end
  
  # Generate a string containing downcase letters, with a random length included
  # between min and max
  def generate_random_string min, max
    (min...rand(max)).map { (97 + rand(26)).chr }.join
  end
  
  def redirection_code flags
    redirect_regex = /^R=?([0-9]{3})?$/
    redirect_regex.match(flags.detect { |flag| redirect_regex.match(flag) })[1] || '302'
  end
  
  def substitute substitute_rule, substituted_data = []
    substitution = substitute_rule
    substitution = "#{@http_scheme}#{@http_host}#{substitution}" unless /^https?\:\/\//.match(substitution)
    substitution = substitution.      
      gsub(/\$[0-9]+?/){ |m| !m.nil? && substituted_data[m[1..-1].to_i] || '' }.
      gsub('%{HTTP_HOST}', @http_host).
      gsub('%{HTTP_SCHEME}', @http_scheme)
  end
end
