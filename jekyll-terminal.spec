Gem::Specification.new do |s|
  s.name        = 'jekyll-terminal'
  s.version     = '0.0.2'
  s.date        = '2014-12-14'
  s.summary     = 'Render shell-commands nicely in a Jekyll'
  s.description = <<END
Add a Liquid block `%terminal` for displaying shell commands
inside a Mac-like terminal. Useful for blogs about programming
that gives command-line instructions.
END
  s.author      = 'Xavier Décoret'
  s.email       = 'xavier.decoret+jekyll@gmail.com'
  s.files       = [
       "lib/jekyll-terminal.rb",
       "lib/jekyll-terminal.scss",
       ]
  s.homepage    = 'https://github.com/Xadeck/jekyll-terminal'
  s.license     = 'MIT'
  
  s.require_paths = ['lib']
  s.add_runtime_dependency 'jekyll', '~> 2.0'
  s.add_development_dependency 'jekyll', '~> 2.0'
  s.required_ruby_version = '~> 2.0'
end