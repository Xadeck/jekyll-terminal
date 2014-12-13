require 'minitest/autorun'
require 'jekyll-terminal'

class TerminalTest < Minitest::Test
  def test_hello
    assert_equal "hello", "hello"
  end
end