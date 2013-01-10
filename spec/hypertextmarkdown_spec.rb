require 'hypertextmarkdown'

ROOT = File.expand_path('../../', __FILE__)

describe "hypertextmarkdown" do
  describe "convert html to markdown" do

    it "handles a basic example" do
      HyperTextMarkDown::to_markdown("1 how's <strong>IT</strong> going?").should == "1 how's **IT** going?\n\n"
    end

    it "ignores unknown tags" do
      HyperTextMarkDown::to_markdown("2 how's <string>IT</string> going?").should == "2 how's IT going?\n\n"
    end

    it "kinda handles a broken tag" do
      HyperTextMarkDown::to_markdown("3 how's <strong IT</strong> going?").should == "3 how's ** going?**\n\n"
    end

    it "kinda handles a different broken tag" do
      HyperTextMarkDown::to_markdown("4 how's <strong>IT</stro\nng> going?").should == "4 how's **IT going?**\n\n"
    end

    it "converts a reasonable sample" do
      html = "<html><body><div class=\"mail_main\"><span>Example</span><hr /><h3>Contact form</h3>\nHello<br />\n<ol>\n<li>Contact Info:\n<ul>\n<li>Name: <strong>Joe Somebody</strong></li>\n<li>E-mail: <a href=\"mailto:somebody@example.com\">somebody@example.com</a></li><li>Code sample: <code>\n#include &lt;stdio.h&gt;\n\nint main(int argc, char** argv) {\nprintf(\"blah\");\nreturn 0;\n}\n</code></li>\n<ul>\n</li>\n<li>Supplemental Info:\n<ul>\n<li>Favorite color: <span>teal</span></li>\n<li>Favorite image: <img alt=\"Fun\" src=\"http://upload.wikimedia.org/wikipedia/commons/e/ec/Happy_smiley_face.png\"/></li>\n</ul>\n</li>\n</ol>\n</div>\n</body></html>"

      expected = "Example\n****\n### Contact form\n\nHello  \n\n  - Contact Info:\n      1. Name: **Joe Somebody**\n      1. E-mail: [somebody@example.com](mailto:somebody@example.com)\n      1. Code sample: \n\n```\n\n#include <stdio.h>\n\nint main(int argc, char** argv) {\nprintf(\"blah\");\nreturn 0;\n}\n\n```\n\n\n  - Supplemental Info:\n      1. Favorite color: teal\n      1. Favorite image: ![Fun](http://upload.wikimedia.org/wikipedia/commons/e/ec/Happy_smiley_face.png)\n\n"

      markdown = HyperTextMarkDown::to_markdown(html)

      markdown.should == expected
    end
  end

end

