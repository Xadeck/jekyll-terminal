require 'rake/testtask'
require "rubygems"

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
  puts "Yeah!"
end

file 'sample.html' => ['sample.md', 'Rakefile'] do |task|
  require_relative 'lib/jekyll-terminal/jekyll-terminal'
  site = Jekyll::Site.new(Jekyll::Configuration::DEFAULTS)
  site.read
  Jekyll::Terminal::StylesheetGenerator.new(site.config).generate(site)
  stylesheet_page = site.pages.find { |p| p.name == 'terminal.scss' }
  template = Liquid::Template.parse(File.read('sample.md'))
  File.open(task.name, 'w') do |file| 
    file.write(%Q{<html>
    <head>
      <style>
#{stylesheet_page.content}      
      </style>
    </head>
    <body>
    <div style='width: 800px; margin: auto'>
#{template.render}    
    </div>
    </body>
</html>}) 
  end
end