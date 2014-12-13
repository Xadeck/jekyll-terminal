require 'jekyll'

module Jekyll
  module Terminal
    # TODO: make this customizable in options.
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
        self.content = File.read(filepath, merged_file_read_opts({}))
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
        output = super(context)
        # TODO: make title customizable.
        %{<div class="window">
            <nav class="control-window">
              <a href="#finder" class="close" data-rel="close">close</a>
              <a href="#" class="minimize">minimize</a>
              <a href="#" class="deactivate">deactivate</a>
            </nav>
            <h1 class="titleInside">Terminal</h1>
            <div class="container"><div class="terminal">#{promptize(output)}</div></div>
          </div>}
      end
    
      def promptize(content)
        content = content.strip
        gutters = content.lines.map { |line| gutter(line) }
        lines_of_code = content.lines.map { |line| line_of_code(line) }

        table = "<table><tr>"
        table += "<td class='gutter'><pre class='line-numbers'>#{gutters.join("\n")}</pre></td>"
        table += "<td class='code'><pre><code>#{lines_of_code.join("")}</code></pre></td>"
        table += "</tr></table>"
      end

      def gutter(line)
        gutter_value = line.start_with?(command_character) ? command_character : "&nbsp;"
        "<span class='line-number'>#{gutter_value}</span>"
      end

      def line_of_code(line)
        if line.start_with?(command_character)
          line_class = "command"
          line = line.sub(command_character,'').strip
        else
          line_class = "output"
        end
        "<span class='line #{line_class}'>#{line}</span>"
      end

      def command_character
        "$"
      end

    end
  end
end

Liquid::Template.register_tag('terminal', Jekyll::Terminal::CommandsBlock)
Liquid::Template.register_tag('terminal_stylesheet', Jekyll::Terminal::StylesheetTag)
