class RewriteRule

  attr_accessor :possibilities, :substitution

  def initialize(line)
    self.parse line
  end

  # Parse an apache RewriteRule and transform it into a Ruby object
  def parse(line)

    match_data = /RewriteRule ([^ ]+) ([^ ]+) \[([^ ]+)\](\n)?$/.match(line)

    return if match_data.nil?

    @regex = match_data[1]
    @possibilities = generate_possibilities @regex
    @substitution = match_data[2].gsub(/\$[0-9]+/, '')
    @flags = match_data[3].split(',')

  end

  def valid?
    !@regex.nil? && !@substitution.nil? && !@flags.nil?
  end

  def redirection?
    !@flags.nil? && @flags.include?('R=301')
  end

  def redirects
    @possibilities.map { |possibility|
      { possibility => @substitution}
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
      "http://www.clicrdv.com#{possibility.gsub('(.*)', '')}"
    }
  end
end