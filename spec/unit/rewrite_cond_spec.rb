require 'rewrite_cond'

describe RewriteCond do
  
  subject = RewriteCond.new('RewriteCond %{HTTP_HOST} ^(.*)example.com$')
  
  describe "#new" do
    context "when the rule is correct" do
      it "parses the rule into two or three parts" do
        compare = subject.instance_variable_get :@compare
        compare.should eql '^(.*)example.com$'

        expression = subject.instance_variable_get :@expression
        expression.should eql '%{HTTP_HOST}'

        flags = subject.instance_variable_get :@flags
        flags.should be nil
      end
    end

    context "when the RewriteCond is not well formatted" do
      it "raises an InvalidRule exception" do
        expect {
          RewriteCond.new('RewriteCond brr')
        }.should raise_error(InvalidRule)
      end
    end
  end
end
