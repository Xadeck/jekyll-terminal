require 'minitest/autorun'
require_relative '../lib/jekyll-terminal/jekyll-terminal'

TEST_DIR     = File.expand_path("../", __FILE__)
DEST_DIR     = File.expand_path("destination", TEST_DIR)

class TerminalTest < Minitest::Test
  def setup
    @site = Jekyll::Site.new(
          Jekyll::Utils.deep_merge_hashes(
            Jekyll::Configuration::DEFAULTS,
            {})
          )
    @site.read
    @terminal = Jekyll::Terminal::StylesheetGenerator.new(@site.config)
  end
  
  def test_stylesheet_page_added
    @terminal.generate(@site)
    page = @site.pages.find { |p| p.name == 'terminal.scss' }
    assert page, "Couldn't find `terminal.scss` page"
    assert_equal "css/terminal.scss", page.path
    # Just check one line (the comment) to ensure content is OK.
    assert_match %r{/\* Window}, page.content 
  end
  
  def test_terminal_block
    content = Liquid::Template.parse(%Q{
{% terminal %}
$ echo "Hello world!"
Hello world!
$ date
Sun Dec 14 09:56:26 CET 2014
$ cat <<END
/This will disappear in void
/END
{% endterminal %}
      }).render
    assert_match %{<span class='command'>echo &quot;Hello world!&quot;</span><br>}, content
    assert_match %{<span class='output'>Hello world!</span><br>}, content
    assert_match %{<span class='command'>cat &lt;&lt;END</span><br>}, content
    assert_match %{<span class='continuation'>This will disappear in void</span><br>}, content
    assert_match %{<span class='continuation'>END</span><br>}, content
  end
end