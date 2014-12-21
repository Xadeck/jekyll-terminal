#jekyll-terminal

This Gem adds a liquid block to Jekyll-powered sites for showing
shell commands in a nice way. The rendering uses only CSS, generated as a site page,
which makes it easily tweakable.

[![Gem Version](https://badge.fury.io/rb/jekyll-terminal.svg)](http://badge.fury.io/rb/jekyll-terminal)

## Basic use

First, add the following tag inside your `head.html` layout.

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

It will get rendered nicely, with a drop shadow, as shown below:

![](https://github.com/Xadeck/jekyll-terminal/blob/master/screenshot.png)

If there is a command that is on multiple line, like an here document, start the line with a slash:

```liquid
{% terminal %}
$ cat <<END
/This will disappear in void
/END
{% endterminal %}
```

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
- [ ] support simple selection of commands only.
- [ ] make path to stylesheet configurable.
- [x] simplify the stylesheet using Sass.
- [ ] add themes for the terminal colors.
- [x] fix the indentation of HEREDOC.

## License
Copyright (c) 2014 Xavier Décoret. MIT license, see [MIT-LICENSE.txt] for details.

[MIT-LICENSE.txt]: https://github.com/bhollis/maruku/blob/master/MIT-LICENSE.txt
