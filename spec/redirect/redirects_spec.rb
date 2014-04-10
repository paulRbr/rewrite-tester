require 'rspec'
require 'net/http'
require 'uri'
require 'redirects'


if ENV['RULES'].nil?
  raise 'Please provide an absolute path to a file containing RewriteRules through a env RULES variable'
end

file = File.new(ENV['RULES'])

subject = Redirects.new file

describe Redirects, ' rules' do
  describe 'All desk rules' do
    subject.rules.each do |rule|

      if rule.redirection?

        rule.redirects.each do |redirection|

          describe "Requesting #{redirection.keys.first}" do
            it "redirects to #{redirection.values.first}" do
              uri = URI.parse(redirection.keys.first)

              # Shortcut
              response = Net::HTTP.get_response(uri)

              response.code.should eql '301'
              response.header['location'].should eql redirection.values.first
            end
          end

        end

      end

    end
  end
end

