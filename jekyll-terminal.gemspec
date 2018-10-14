Gem::Specification.new do |s|
  s.name        = 'jekyll-terminal'
  s.version     = '0.1.5'
  s.date        = '2018-10-10'
  s.summary     = 'Render shell-commands nicely in a Jekyll'
  s.description = <<END
Add a Liquid block `%terminal` for displaying shell commands
nicely in HTML. Useful for Jekyll-based blogs about programming
that gives command-line instructions.
END
  s.author      = 'Xavier Décoret'
  s.email       = 'xavier.decoret+jekyll@gmail.com'
  s.files       = [
       "lib/jekyll-terminal.rb",
       "lib/terminal.scss",
       ]
  s.homepage    = 'https://github.com/Xadeck/jekyll-terminal'
  s.license     = 'MIT'

  s.require_paths = ['lib']
  s.add_runtime_dependency 'jekyll', ['>= 3.1.3', '< 4.0']
end
