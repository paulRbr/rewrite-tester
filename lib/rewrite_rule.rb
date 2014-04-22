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

    @regex = match_data[1]
    @possibilities = generate_possibilities @regex
    @substitution = substitute match_data[2]
    @flags = match_data[3].split(',')

  end

  def valid?
    !@regex.nil? && !@substitution.nil? && !@flags.nil?
  end

  def redirection?
    !@flags.nil? && @flags.any?{ |flag| /^R/.match(flag) }
  end

  def redirects
    @possibilities.map { |possibility|
      { possibility => { :substitution => @substitution, :code => redirection_code(@flags) } }
    }
  end

  def generate_possibilities regex
    some = []
    base = regex.gsub(/\^|\$/,'')

    # Maybe will generate two possibilities, with and without
    maybe_regex = /\(([^*+]+)\)\?/
    match_data = maybe_regex.match(base)
    if match_data.nil?
      some << base
    else
      some << base.gsub(match_data[0], match_data[1])
      some << base.gsub(match_data[0], '')
    end

    # Anything will be replaced by nothing
    some.map { |possibility|
      "#{@http_scheme}#{@http_host}#{possibility.gsub('(.*)', '')}"
    }
  end
  
  private
  
  def redirection_code flags
    redirect_regex = /^R=?([0-9]{3})?$/
    redirect_regex.match(flags.detect { |flag| redirect_regex.match(flag) })[1] || '302'
  end
  
  def substitute substitute_rule
    substitution = substitute_rule
    substitution = "#{@http_scheme}#{@http_host}#{substitution}" if /^\//.match(substitution)
    substitution = substitution.      
      gsub(/\$[0-9]+/, '').
      gsub('%{HTTP_HOST}', @http_host).
      gsub('%{HTTP_SCHEME}', @http_scheme)
  end
end
