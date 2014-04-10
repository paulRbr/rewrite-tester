Gem::Specification.new do |s|
  s.name        = 'rewrite-tester'
  s.version     = '0.0.2'
  s.date        = '2014-04-10'
  s.summary     = "Make HTTP request and test answers"
  s.description = "This tool was built to do full integration testing of HTTP requests"
  s.authors     = ["Paul Bonaud"]
  s.email       = 'paul.bonaud@clicrdv.com'
  s.files       = Dir.glob("{lib}/**/*") + %w(LICENSE README.md)
  s.add_dependency 'rake'
  s.add_dependency 'rspec'
  s.homepage    = 'http://rubygems.org/gems/rewrite-tester'
  s.license     = 'MIT'
end
