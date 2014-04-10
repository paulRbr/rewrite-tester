require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

namespace :test do
  task :redirects => :spec
end

task :default => :spec
