require 'rake/testtask'
require 'rubygems'

SPEC = Gem::Specification::load('jekyll-terminal.spec')
NAME = SPEC.name
VERSION = SPEC.version

Rake::TestTask.new do |t|
  t.libs << 'test'
end

desc "Run tests"
task :default => :test

desc "Check git status is clean"
task :check_git do
  puts "# Checking git status"
  sh %Q{test "$(git status --porcelain)" == ""} do |ok|
    abort("Repository is not clean, aborting!") if !ok
  end
end

desc "Build the Ruby gem for jekyll-terminal"
task :build do
  puts "# Building gem"
  system %Q{gem build jekyll-terminal.spec}
end

desc "Deploy to RubyGems"
task :deploy => [:test, :check_git, :build] do
  puts "# Tagging directory"
  system %Q{git tag -f #{VERSION}}
  puts "# Deploying Gem"
  system %Q{gem push #{NAME}-#{VERSION}.gem}
  puts "# Deploy complete"
end

desc "Generates a sample rendering of a terminal"
task :sample => 'sample.html' do
  require_relative 'lib/jekyll-terminal/jekyll-terminal'
  require 'sass'
  # Fake a site to have the generator producer the .scss page.
  site = Jekyll::Site.new(Jekyll::Configuration::DEFAULTS)
  site.read
  Jekyll::Terminal::StylesheetGenerator.new(site.config)
  site.generate
  scss_page = site.pages.find { |p| p.name == 'terminal.scss' }
  # Transform it in CSS by running sass. Would be better to use the site to generate it.
  css = Sass::Engine.new(scss_page.content, :syntax => :scss).render
  # Generate the HTML for the liquid template
  sample_md = File.read('sample.md')
  sample_html = Liquid::Template.parse(sample_md).render
  # Combine all together in a simple
  File.open('sample.html', 'w') do |file|
    file.write(%Q{<html>
    <head>
      <style>
#{css}
      </style>
    </head>
    <body>
    <div style='width: 800px; margin: auto'>
    <pre>#{sample_md}</pre>
#{sample_html}
    </div>
    </body>
</html>})
 end
end