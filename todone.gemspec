# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{todone}
  s.version = "0.2.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["A Flores"]
  s.date = %q{2011-06-11}
  s.default_executable = %q{todone}
  s.description = %q{Toone is a command-line tool that gives you the ability to better integrate git with your project manager(which is currently only allowed to be pivotal tracker). Todone will keep track of the tickets your working on so you don't have to.}
  s.email = %q{ctrl4ltdeleteme@gmail.com}
  s.executables = ["todone"]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".document",
    ".rvmrc",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION",
    "bin/todone",
    "git_config_read_test",
    "lib/todone.rb",
    "lib/todone/config.rb",
    "lib/todone/consts.rb",
    "lib/todone/pivotal_puller.rb",
    "lib/todone/views.rb",
    "spec/helper.rb",
    "spec/libs/config_spec.rb",
    "spec/libs/message_processor_spec.rb",
    "spec/libs/pivotal_puller_spec.rb",
    "todone.gemspec"
  ]
  s.homepage = %q{http://github.com/unflores/todone}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Todone is a command-line tool that gives you the ability to better integrate git with your pivotal project.}
  s.test_files = [
    "spec/helper.rb",
    "spec/libs/config_spec.rb",
    "spec/libs/message_processor_spec.rb",
    "spec/libs/pivotal_puller_spec.rb"
  ]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<commander>, ["= 4.0.3"])
      s.add_runtime_dependency(%q<crack>, ["= 0.1.8"])
      s.add_runtime_dependency(%q<httparty>, ["= 0.7.4"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<mocha>, ["= 0.9.12"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
    else
      s.add_dependency(%q<commander>, ["= 4.0.3"])
      s.add_dependency(%q<crack>, ["= 0.1.8"])
      s.add_dependency(%q<httparty>, ["= 0.7.4"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<mocha>, ["= 0.9.12"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_dependency(%q<rcov>, [">= 0"])
    end
  else
    s.add_dependency(%q<commander>, ["= 4.0.3"])
    s.add_dependency(%q<crack>, ["= 0.1.8"])
    s.add_dependency(%q<httparty>, ["= 0.7.4"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<mocha>, ["= 0.9.12"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
    s.add_dependency(%q<rcov>, [">= 0"])
  end
end

