require 'rake/testtask'
require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "monad-maybe"
  gem.summary = %Q{A Ruby implementation of Haskell's Maybe Monad}
  gem.description = %Q{This is an attempt to implement Haskell's Maybe monad in a Ruby-ish way.}
  gem.email = "delon.newman@gmail.com"
  gem.homepage = "https://github.com/delonnewman/monad-maybe"
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

Rake::TestTask.new do |t|
  t.libs << 'test'
end
