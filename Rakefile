require 'jeweler'
require 'fileutils'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "dragnet"
  gem.summary = %Q{A recruitment workflow system for research projects}
  gem.description = %Q{A recruitment workflow system for research projects developed at PHREI}
  gem.email = "drnewman@phrei.org"
  gem.homepage = "http://phrei.org"
  gem.authors = ["Delon Newman"]
end
Jeweler::RubygemsDotOrgTasks.new

desc "Run tests in ./test"
task :test do
  Dir['test/*.rb'].each do |test|
    sh "ruby #{test}"
  end
end

desc "Setup for development"
task :setup do
  sh "bundle"
end

def version
  @version ||= IO.read("VERSION").chomp
end

def appgem
  "dragnet-#{version}.gem"
end

def deploy_dir
  "A:\\apps\\dragnet\\#{version}"
end

task "Build gem using gem build"
task :build_gem => :gemspec do
  sh "gem build dragnet.gemspec"
end

desc "Deploy to gem for installation"
task :deploy_gem => :build_gem do
  puts "Deploying #{version}..."
  dir = deploy_dir
  FileUtils.mkdir_p(dir) unless File.exists?(dir)
  FileUtils.copy(appgem, dir)
  FileUtils.cp_r("extra", dir)
  File.open('A:\\apps\\dragnet\\latest', 'w') { |f| f.write(IO.read('VERSION')) }
  puts "Successfully deployed #{appgem} to #{dir}."
end
