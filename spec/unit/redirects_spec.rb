require 'redirects'

describe Redirects do
  describe "#new" do

    it "creates RewriteConds or rewriteRules from the file lines" do            
      RewriteRule.should_receive(:new).exactly(1).times
      RewriteCond.should_receive(:new).exactly(1).times

      file = <<EOS
RewriteCond %{HTTP_HOST} ^(.*)example.com$
RewriteRule ^/(fr/)?doc-(.*)$ http://doc.example.com/fr/doc-$2.html [R=301,L]      
EOS

      redirects = Redirects.new StringIO.new(file)
    end
  end

  describe "self#substitute" do
  end
end
