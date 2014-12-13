require 'minitest/autorun'
require 'jekyll-terminal'

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
end