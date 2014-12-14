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
