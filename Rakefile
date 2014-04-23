require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern =  "spec/unit/**/*_spec.rb"  
end

namespace :try do
  RSpec::Core::RakeTask.new(:redirects) do |t|
    t.pattern =  "spec/redirect/**/*_spec.rb"  
  end
end

task :default => :spec
