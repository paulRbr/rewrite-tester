require 'rspec'
require 'net/http'
require 'uri'
require 'redirects'


if ENV['RULES'].nil?
  raise 'Please provide an absolute path to a file containing RewriteRules through a env RULES variable'
end

file = File.new(ENV['RULES'])
http_host = ENV['HTTP_HOST']
http_scheme = ENV['HTTP_SCHEME']

subject = Redirects.new file

describe Redirects, 'rules' do
  subject.rules.each do |rule|

    if rule.redirection?
      rule.redirects.each do |redirection|

        describe rule.line do
          describe "Requesting #{redirection[:possibility]}" do
            it "redirects to #{redirection[:substitution]}" do
              uri = URI.parse(redirection[:possibility])

              response = Net::HTTP.get_response(uri)

              response.code.should eql redirection[:code]
              URI.unescape(response.header['location']).should eql redirection[:substitution]
            end
          end
        end

      end
    end

  end
end
