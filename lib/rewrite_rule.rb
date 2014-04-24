require 'redirects'
require 'invalid_rule'
require 'untestable'

class RewriteRule

  attr_accessor :possibilities, :substitution, :line

  def initialize(line, conditions = [])
    @line = line
    @conds = conditions

    self.parse line

    raise Untestable.new unless @conds.empty?
    raise InvalidRule.new unless valid?
  end

  # Parse an apache RewriteRule and transform it into a Ruby object
  def parse(line)
    match_data = /RewriteRule[ ]+([^ ]+)[ ]+([^ ]+)([ ]+\[([^ ]+)\]\n?)?$/.match(line)

    return if match_data.nil?

    @regex = match_data[1]
    @possibilities = generate_possibilities @regex
    @substitution = match_data[2]
    @substitutions = @possibilities.map do |possibility|
      ::Redirects.substitute @substitution, possibility[:substituted_data]
    end
    @flags = match_data[4].nil? ? nil : match_data[4].split(',')

  end

  def valid?
    !@regex.nil? && !@substitution.nil?
  end

  def redirection?
    !@flags.nil? && @flags.any?{ |flag| /^R/.match(flag) }
  end

  def redirects
    @substitutions.map.with_index do |substitution, i|
      request = ::Redirects.substitute(@possibilities[i][:request_uri])
      response = substitution.nil? ? request : substitution
      { 
        :possibility => request,
        :substitution => response,
        :code => redirection_code(@flags)
      }
    end
  end

  def last?
    !@flags.nil? && @flags.include?('L')
  end

  private

  def generate_possibilities regex
    some = []
    base = regex.gsub(/\^|\$/,'')

    capture_regex = /\(([^)^(]+?)\)\??/
    match_data = capture_regex.match(base)
    substituted_data = []
    until match_data.nil?    
      matched = match_data[1]
      if /\.\*/.match(matched)
        # Match anything -> Replace by a random string
        matched = matched.gsub('.*', generate_random_string(0, 8))
      elsif /\?$/.match(match_data[0])            
        # Maybe regex -> Replace by match or by empty string
        matched = rand(2) == 0 ? matched : ''
      end
      
      base = base.gsub(match_data[0], matched)
      substituted_data << matched
      match_data = capture_regex.match(base)
    end

    any_regex = /(\.\*)/
    match_data = any_regex.match(base)
    until match_data.nil?
      matched = match_data[1]
      matched = matched.gsub('.*', generate_random_string(0, 8))
      base = base.gsub(match_data[0], matched)
      match_data = any_regex.match(base)
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
end
