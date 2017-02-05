require 'minitest/autorun'
require_relative '../lib/jekyll-terminal'

TEST_DIR     = File.expand_path("../", __FILE__)
DEST_DIR     = File.expand_path("destination", TEST_DIR)

module TestHelpers
  def setup_site(config)
    @site = Jekyll::Site.new(
          Jekyll::Utils.deep_merge_hashes(
            Jekyll::Configuration::DEFAULTS,
            config.merge({"source" => "test"}))
          )
    @site.read
    @terminal = Jekyll::Terminal::StylesheetGenerator.new(@site.config)
    @context = Liquid::Context.new
    @context.registers[:site] = @site
  end

  def render_template(template)
    Liquid::Template.parse(template).render(@context)
  end
end


class TerminalTest < Minitest::Test
  include TestHelpers

  def setup
    setup_site({})
  end

  def test_stylesheet_page_added
    @terminal.generate(@site)
    page = @site.pages.find { |p| p.name == 'terminal.scss' }
    assert page, "Couldn't find `terminal.scss` page"
    assert_equal "css/terminal.scss", page.path
    # Just check one line (the comment) to ensure content is OK.
    assert_match "font-family: monospace;", page.content
  end

  def test_terminal_block
    content = render_template(%Q{
{% terminal %}
$ echo "Hello world!"
Hello world!
$ date
Sun Dec 14 09:56:26 CET 2014
$ cat <<END
/This will disappear in void
/END
{% endterminal %}
      })
    assert_match %{<span class='command'>echo &quot;Hello world!&quot;</span>}, content
    assert_match %{<span class='output'>Hello world!</span>}, content
    assert_match %{<span class='command'>cat &lt;&lt;END</span>}, content
    assert_match %{<span class='continuation'>This will disappear in void</span>}, content
    assert_match %{<span class='continuation'>END</span>}, content
    assert_match %{<h3 class="title">Terminal</h3>}, content
  end
end

class ConfiguredTerminalTest < Minitest::Test
  include TestHelpers

  def setup
    setup_site :terminal => {
      :tag_name => 'h4',
      :continuation_string => '$/'
    }
  end

  def test_terminal_block
    content = render_template(%Q{
{% terminal %}
$ locate stdio.h
/usr/include/stdio.h
$ cat <<END
$/This will disappear in void
$/END
{% endterminal %}
      })
    assert_match %{<h4 class="title">Terminal</h4>}, content
    assert_match %{<span class='command'>locate stdio.h</span>}, content
    assert_match %{<span class='output'>/usr/include/stdio.h</span>}, content
    assert_match %{<span class='command'>cat &lt;&lt;END</span>}, content
    assert_match %{<span class='continuation'>This will disappear in void</span>}, content
    assert_match %{<span class='continuation'>END</span>}, content
  end
end

class BadConfiguredTerminalTest < Minitest::Test
  include TestHelpers

  def setup
    setup_site :terminal => {
      :continuation_string => '$'
    }
  end

  def test_terminal_block
    content = render_template(%Q{
{% terminal %}
$ cat <<END
/This will disappear in void
/END
{% endterminal %}
      })
    assert_match %{<span class='command'>cat &lt;&lt;END</span>}, content
    assert_match %{<span class='continuation'>This will disappear in void</span>}, content
    assert_match %{<span class='continuation'>END</span>}, content
  end

end


