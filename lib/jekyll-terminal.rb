require 'jekyll'
require 'cgi'

module Jekyll
  module Terminal
    def Terminal.dir(site)
      'css'
    end

    def Terminal.basename(site)
      'terminal'
    end

    # Page that reads its contents from the Gem `terminal.sass` file.
    class StylesheetPage <  Page
      def initialize(site, base, dir)
        @site = site
        @base = base
        @dir = dir
        @name = Jekyll::Terminal::basename(site)+ '.scss'

        self.process(@name)

        filepath = File.join(File.dirname(File.expand_path(__FILE__)), @name)
        self.content = File.read(filepath, Utils.merged_file_read_opts(self.site, {}))
        self.data ||= {}
      end
    end

    # Generator that adds the stylesheet page to the generated site.
    class StylesheetGenerator < Generator
      safe true

      def generate(site)
        site.pages << StylesheetPage.new(site, site.source, Jekyll::Terminal::dir(site))
      end
    end

    class StylesheetTag < Liquid::Tag
      def initialize(tag_name, text, tokens)
        super
        @text = text
      end

      def render(context)
        site = context.registers[:site]
        url =  Jekyll::Terminal::dir(site) + '/' + Jekyll::Terminal::basename(site)
        "<link rel='stylesheet' href='#{site.baseurl}/#{url}.css'>"
      end
    end

    class CommandsBlock < Liquid::Block

      def initialize(tag_name, text, tokens)
        super
        @text = text
      end

      def render(context)
        site = context.registers[:site]
        terminal_config = site.config[:terminal] || {}
        tag_name = terminal_config[:tag_name] || 'h3'
        continuation_string = terminal_config[:continuation_string] || '/'
        continuation_string = '/' if continuation_string == '$'
        content = super(context).strip.lines.map do |line|
          # Test the continuation string first, because it may start with '$'.
          # Note that it can't be '$' thanks to the guard above.
          if line.start_with?(continuation_string)
             "<span class='continuation'>#{esc line[continuation_string.size..-1]}</span>"          
          elsif line.start_with?("$")
             "<span class='command'>#{esc line[1..-1]}</span>"
          else
             "<span class='output'>#{esc line}</span>"
          end
        end.join("\n")
        %{
<div class="terminal">
  <nav>
    <a href="#" class="close">close</a>
    <a href="#" class="minimize">minimize</a>
    <a href="#" class="deactivate">deactivate</a>
  </nav>
  <#{tag_name} class="title">Terminal</#{tag_name}>
  <pre>
#{content}
  </pre>
</div>}
      end

      def esc(line)
        CGI.escapeHTML(line.strip)
      end

    end
  end
end

Liquid::Template.register_tag('terminal', Jekyll::Terminal::CommandsBlock)
Liquid::Template.register_tag('terminal_stylesheet', Jekyll::Terminal::StylesheetTag)
