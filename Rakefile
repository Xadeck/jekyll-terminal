require 'rake/testtask'
require 'rubygems'
require 'cgi'

SPEC = Gem::Specification::load('jekyll-terminal.gemspec')
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
  system %Q{gem build jekyll-terminal.gemspec}
end

desc "Deploy to RubyGems"
task :deploy => [:test, :sample, :check_git, :build] do
  puts "# Tagging directory"
  system %Q{git tag -f #{VERSION}}
  puts "# Deploying Gem"
  system %Q{gem push #{NAME}-#{VERSION}.gem}
  puts "# Deploy complete"
end

desc "Generates a sample rendering of a terminal"
task :sample => 'sample.html' do
  puts "# Generating sample"
  require_relative 'lib/jekyll-terminal'
  require 'sass'
  # Fake a site to have the generator producer the .scss page.
  site = Jekyll::Site.new(
    Jekyll::Utils.deep_merge_hashes(
      Jekyll::Configuration::DEFAULTS,
      {"source" => "test"}
    )
  )
  site.read
  Jekyll::Terminal::StylesheetGenerator.new(site.config)
  site.generate
  scss_page = site.pages.find { |p| p.name == 'terminal.scss' }
  # Transform it in CSS by running sass. Would be better to use the site to generate it.
  css = Sass::Engine.new(scss_page.content, :syntax => :scss).render
  # Generate the HTML for the liquid template
  context = Liquid::Context.new
  context.registers[:site] = site
  sample_md = File.read('sample.md')
  sample_html = Liquid::Template.parse(sample_md).render(context)
  # Generate a copy of the sample with the CSS class changed to disable 
  # stylesheet (since the scoped attribute on the <div>< element is not yet supported).
  unstyled_sample_html = sample_html.sub(%Q{class="terminal"}, "")
  # Combine all together in a simple file.
  File.open('sample.html', 'w') do |file|
    file.write(%Q{<!DOCTYPE html>
<html>
  <head>
  	<meta charset="utf-8">
    <title>Sample for jekyll-template</title>
    <style>
      body > div {
        width: 800px; 
        margin: auto;
      }
      p { 
        font-family: Helvetica 
      }
      pre {
        padding: 1em;
        overflow: auto;
        line-height: 1.45;
        background-color: #f7f7f7;
        border-radius: 3px;
      }
    </style>
  </head>
  <body>
    <div>
      <p>The following snippet:</p>
      <pre>#{CGI.escapeHTML(sample_md)}</pre>
      <p>will be rendered like this with CSS:</p>
      <div>
        <style scoped>#{css}</style>
#{sample_html}
      </div>
      <p>and like that if CSS is disabled:</p>
      <div>
#{unstyled_sample_html}
      </div>
    </div>
  </body>
</html>})
 end
end
