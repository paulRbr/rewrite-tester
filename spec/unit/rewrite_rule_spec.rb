require 'rspec'
require 'rewrite_rule'


describe RewriteRule do
  
  subject = RewriteRule.new('RewriteRule ^/(fr/)?doc-(.*)$ http://example.com/fr/doc-$2.html [R=301,L]')
  
  describe "#generate_possibilities" do
              
    regexps = ['^/fr(/.*)?$', '^/fr/(index(/.*)?)?$', '^/(fr/)?doc-(.*)$']
    
    regexps.each do |regexp|
      context "For regex #{regexp}" do      
        it "generates acceptable substitutions" do
          subject.send(:generate_possibilities, regexp).each do |possibility|
            possibility[:request_uri].should match Regexp.new(regexp)
          end
        end
      end
    end
    
  end
  
  describe "#new" do
    
    it "parses the rule into three parts, the regex, the substitution and the flags" do
      regex = subject.instance_variable_get :@regex
      regex.should eql '^/(fr/)?doc-(.*)$'
      
      substitution = subject.instance_variable_get :@substitution
      substitution.should eql 'http://example.com/fr/doc-$2.html'
      
      flags = subject.instance_variable_get :@flags
      flags.should include 'R=301'
      flags.should include 'L'
    end
    
  end
  
end
