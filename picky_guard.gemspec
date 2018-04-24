# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'picky_guard/version'

Gem::Specification.new do |spec|
  spec.name          = 'picky_guard'
  spec.version       = PickyGuard::VERSION
  spec.authors       = ['Eunjae Lee']
  spec.email         = ['karis612@gmail.com']

  spec.summary       = 'PickyGuard is an opinionated authorization library.'
  spec.description   = spec.description
  spec.homepage      = 'https://github.com/eunjae-lee/picky_guard'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord', '>= 4.2'
  spec.add_dependency 'cancancan', '>= 2.0'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.2'
  spec.add_development_dependency 'rubocop', '~> 0.55.0'
  spec.add_development_dependency 'sqlite3', '~> 1.3.13'
end
