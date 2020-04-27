# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name          = "jekyll-tagories"
  s.version       = "0.1.0"
  s.license       = "MIT"
  s.authors       = ["Ashwin Maroli"]
  s.email         = ["ashmaroli@gmail.com"]
  s.homepage      = "https://github.com/ashmaroli/jekyll-tagories"
  s.summary       = "Jekyll plugin to allow iterating through tagged or categorized documents"
  s.description   = "A Jekyll plugin that allows iterating through tagged or categorized documents in user-defined collections"

  s.files         = `git ls-files lib`.split("\n").concat(%w(LICENSE README.md))
  s.require_paths = ["lib"]

  s.required_ruby_version = ">= 2.4.0"
  s.add_runtime_dependency "jekyll", ">= 3.7", "< 5.0"

  s.add_development_dependency "cucumber", "~> 3.0"
  s.add_development_dependency "rspec", "~> 3.0"
  s.add_development_dependency "rubocop-jekyll", "~> 0.11.0"
end
