# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "monad-maybe"
  s.version = "0.9.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Delon Newman"]
  s.date = "2013-08-16"
  s.description = "This is an attempt to implement Haskell's Maybe monad in a Ruby-ish way."
  s.email = "delon.newman@gmail.com"
  s.extra_rdoc_files = [
    "README.md"
  ]
  s.files = [
    "Gemfile",
    "Gemfile.lock",
    "README.md",
    "Rakefile",
    "VERSION",
    "lib/monad/maybe.rb",
    "lib/monad/maybe/base.rb",
    "lib/monad/maybe/json.rb",
    "lib/monad/maybe/just.rb",
    "lib/monad/maybe/list.rb",
    "lib/monad/maybe/nothing.rb",
    "monad-maybe.gemspec",
    "test/maybe.rb"
  ]
  s.homepage = "https://github.com/delonnewman/monad-maybe"
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.0"
  s.summary = "A Ruby implementation of Haskell's Maybe Monad"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
      s.add_development_dependency(%q<test-unit>, [">= 0"])
    else
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0"])
      s.add_dependency(%q<test-unit>, [">= 0"])
    end
  else
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0"])
    s.add_dependency(%q<test-unit>, [">= 0"])
  end
end

