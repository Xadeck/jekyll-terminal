This Gem adds a liquid block to Jekyll-powered sites for showing
shell commands in a nice way.

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

It will get rendered nicely as shown below:

![](https://github.com/Xadeck/jekyll-terminal/blob/master/screenshot.png)

## To be done

- [ ] make path to stylesheet configurable
- [ ] simplify the stylesheet using Sass
- [ ] add themes for the terminal colors
