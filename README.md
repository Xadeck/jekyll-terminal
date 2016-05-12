#jekyll-terminal

[![Join the chat at https://gitter.im/Xadeck/jekyll-terminal](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/Xadeck/jekyll-terminal?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

This Gem adds a liquid block to Jekyll-powered sites for showing
shell commands in a nice way. The rendering uses only CSS, generated as a site page,
which makes it easily tweakable.

[![Gem Version](https://badge.fury.io/rb/jekyll-terminal.svg)](http://badge.fury.io/rb/jekyll-terminal)
[![Build status](https://travis-ci.org/Xadeck/jekyll-terminal.png?branch=master)](https://travis-ci.org/jekyll-terminal/)
## Basic use

First, add the plugin to your jekyll site, by putting the following lines in your `_config.yml` file inside the generaged jekyll directory.
```yaml
gems: 
  - jekyll-terminal
```

Then, add the following tag inside your `_includes/head.html` layout, next to the existing stylesheets tags.

```liquid
{% terminal_stylesheet %}    
```

Then, in any posts, simply wrap shell instructions inside a `terminal` block:

```liquid
{% terminal %}
$ echo "Hello world!"
Hello world
$ date
Sun Dec 14 09:56:26 CET 2014
{% endterminal %}
```

It will get rendered nicely, with a drop shadow, as shown on snapshot below:

![](https://github.com/Xadeck/jekyll-terminal/blob/master/screenshot.png)

Download the self-contained `sample.html` file in this repository to see how it is rendered in your favorite browser. Or check an [online rendering](http://htmlpreview.github.io/?https://github.com/Xadeck/jekyll-terminal/blob/master/sample.html).

## Advanced use
Lines starting with `$ ` are considered commands and will be rendered as such. If you need a command on multiple line, like an here document, start the line with a slash:

```liquid
{% terminal %}
$ cat <<END
/This will disappear in void
/END
{% endterminal %}
```

Anyother line (not starting with `$` or `/`) will be considered output. In the rendered HTML, output lines are marked as non user selectable (a feature supported by some browsers). Similarly, command lines are rendered with the `$ ` added via CSS. As a result, it is very easy for your viewers to copy/paste a list of commands from your page to their terminal.

## Configuration

The following variables can be specified in the `_config.yml` file of your jekyll site:

```yaml
terminal:
  tag_name: 'h3'  # the tag used for the Terminal's title
```

## To be done

- [x] fix the table layout for long commands.
- [ ] make title of terminal customizable.
- [x] support multiline commands.
- [x] support simple selection of commands only.
- [ ] make path to stylesheet configurable.
- [x] simplify the stylesheet using Sass.
- [ ] add themes for the terminal colors.
- [x] fix the indentation of HEREDOC.

## License
Copyright (c) 2014 Xavier Décoret. MIT license, see [MIT-LICENSE.txt] for details.

[MIT-LICENSE.txt]: https://github.com/bhollis/maruku/blob/master/MIT-LICENSE.txt
