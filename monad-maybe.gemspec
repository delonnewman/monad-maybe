# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: monad-maybe 0.9.11 ruby lib

Gem::Specification.new do |s|
  s.name = "monad-maybe".freeze
  s.version = "0.9.11"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Delon Newman".freeze]
  s.date = "2018-11-06"
  s.description = "This is an attempt to implement Haskell's Maybe monad in a Ruby-ish way.".freeze
  s.email = "delon.newman@gmail.com".freeze
  s.extra_rdoc_files = [
    "README.md"
  ]
  s.files = [
    ".ruby-version",
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
  s.homepage = "https://github.com/delonnewman/monad-maybe".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.6.11".freeze
  s.summary = "A Ruby implementation of Haskell's Maybe Monad".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<jeweler>.freeze, ["~> 2.3.9"])
      s.add_development_dependency(%q<yard>.freeze, [">= 0.9.11"])
      s.add_development_dependency(%q<test-unit>.freeze, [">= 0"])
    else
      s.add_dependency(%q<jeweler>.freeze, ["~> 2.3.9"])
      s.add_dependency(%q<yard>.freeze, [">= 0.9.11"])
      s.add_dependency(%q<test-unit>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<jeweler>.freeze, ["~> 2.3.9"])
    s.add_dependency(%q<yard>.freeze, [">= 0.9.11"])
    s.add_dependency(%q<test-unit>.freeze, [">= 0"])
  end
end

