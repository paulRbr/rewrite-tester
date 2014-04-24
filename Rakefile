require 'rspec/core/rake_task'

# ========================
#  Main 
# ========================
namespace :try do
  desc "Run RewriteTester against the RULE= file provided as ENV variable"
  RSpec::Core::RakeTask.new(:redirects) do |t|
    t.rspec_opts = ["-c", "-f progress"]
    t.pattern =  "spec/redirect/**/*_spec.rb"  
  end
end
# ========================

RSpec::Core::RakeTask.new(:spec) do |task|
  task.rspec_opts = ["-c", "-f progress", "-r ./spec/spec_helper.rb"]
  task.pattern = 'spec/unit/**/*_spec.rb'
end

require 'coveralls/rake/task'
Coveralls::RakeTask.new
task :spec_with_coveralls => [:spec, 'coveralls:push']

task :default => :spec
