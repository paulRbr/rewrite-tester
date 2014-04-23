require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern =  "spec/unit/**/*_spec.rb"  
end

namespace :try do
  desc "Run RewriteTester against the RULE= file provided as ENV variable"
  RSpec::Core::RakeTask.new(:redirects) do |t|
    t.pattern =  "spec/redirect/**/*_spec.rb"  
  end
end

task :default => :spec
