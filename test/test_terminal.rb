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
  
  def test_hello
    assert_equal "hello", "hello"
  end
end