require 'rspec'
require 'net/http'
require 'uri'
require 'redirects'


if ENV['RULES'].nil?
  raise 'Please provide an absolute path to a file containing RewriteRules through a env RULES variable'
end

file = File.new(ENV['RULES'])
http_host = ENV['HTTP_HOST']

subject = Redirects.new file, http_host

describe Redirects, 'rules' do
  subject.rules.each do |rule|

    if rule.redirection?
      rule.redirects.each do |redirection|

        describe rule.line do
          describe "Requesting #{redirection.keys.first}" do
            it "redirects to #{redirection.values.first[:substitution]}" do
              uri = URI.parse(redirection.keys.first)

              # Shortcut
              response = Net::HTTP.get_response(uri)

              response.code.should eql redirection.values.first[:code]
              URI.unescape(response.header['location']).should eql redirection.values.first[:substitution]
            end
          end
        end

      end
    end

  end
end
