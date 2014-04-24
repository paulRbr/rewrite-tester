require 'rewrite_rule'

describe RewriteRule do
  
  subject = RewriteRule.new('RewriteRule ^/(fr/)?doc-(.*)$ http://doc.example.com/fr/doc-$2.html [R=301,L]')
  
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

    context "when the RewriteRule is correct" do
      it "parses the rule into three parts, the regex, the substitution and the flags" do
        regex = subject.instance_variable_get :@regex
        regex.should eql '^/(fr/)?doc-(.*)$'

        substitution = subject.instance_variable_get :@substitution
        substitution.should eql 'http://doc.example.com/fr/doc-$2.html'

        flags = subject.instance_variable_get :@flags
        flags.should include 'R=301'
        flags.should include 'L'
      end
    end

    context "when the RewriteRule is not well formatted" do
      it "raises an InvalidRule exception" do
        expect {
          RewriteRule.new('df brr')
        }.should raise_error
        expect {
          RewriteRule.new('RewriteRule abc')
        }.should raise_error
      end
    end

  end

  describe "#last? rule" do
    context "with a L flagged RewriteRule" do
      last = RewriteRule.new('RewriteRule ^/index\.html$ - [L]')
      it "returns true" do
        last.last?.should be true
      end
    end
    context "with a non L flagged RewriteRule" do
      not_last = RewriteRule.new('RewriteRule ^/index\.html$ - [R=301]')
      it "returns false" do
        not_last.last?.should be false
      end
    end
  end
  
  describe "#redirects" do

    redirection = subject.redirects.first

    it "creates the three elements needed to test the redirection (possibility, substitution and http code)" do
      match_data = Regexp.new('/(fr/)?doc-(.*)$').match redirection[:possibility]
      match_data.should_not be nil
      redirection[:substitution].should eql 'http://doc.example.com/fr/doc-$2.html'.gsub('$2', match_data[2])
      redirection[:code].should eql '301'
    end

  end

end
