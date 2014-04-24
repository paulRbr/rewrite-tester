require 'redirects'

describe Redirects do
  describe "#new" do

    context "with incorrect syntax rules" do
      it "raise an error with the line number where the syntax is wrong" do
        file = 'RewriteRule ^/(fr/)?doc-(.*)$'

        expect {
          Redirects.new StringIO.new(file)
        }.should raise_error(RuntimeError, /line 1/i)
      end
    end

    context "with correct syntax rules" do
      it "creates rewriteRules from the file lines" do
        RewriteRule.should_receive(:new).exactly(2).times

        file = <<EOS
RewriteRule ^/(fr/)?doc-(.*)$ http://doc.example.com/fr/doc-$2.html [R=301,L]
RewriteRule ^/(fr/)?doc-(.*)$ http://doc.example.com/fr/doc-$2.html [R=301,L]
EOS

        Redirects.new StringIO.new(file)
      end

      it "from another example it creates a rewriteRule and a rewriteCond" do
        RewriteCond.should_receive(:new).exactly(1).times
        STDOUT.should_receive(:puts).exactly(1).times

        file = <<EOS
RewriteCond %{HTTP_HOST} ^(.*)example.com$
RewriteRule ^/(fr/)?doc-(.*)$ http://doc.example.com/fr/doc-$2.html [R=301,L]
EOS

        Redirects.new StringIO.new(file)
      end
    end
  end

  describe "self#substitute" do
  end
end
