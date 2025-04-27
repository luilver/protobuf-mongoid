# frozen_string_literal: true

require_relative 'lib/protobuf/mongoid/version'

Gem::Specification.new do |spec|
  spec.name          = 'protobuf-mongoid'
  spec.version       = Protobuf::Mongoid::VERSION
  spec.authors       = ['Luilver Garces']
  spec.email         = ['luilver@gmail.com']
  spec.summary       = 'A gem to integrate Protocol Buffers with Mongoid.'
  spec.description   = 'This gem provides functionality to serialize and deserialize Mongoid documents using Protocol Buffers.'
  spec.homepage      = 'https://github.com/yourusername/protobuf-mongoid'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*', 'README.md', 'LICENSE.txt']
  spec.require_paths = ['lib']

  ##
  # Dependencies
  #
  spec.add_dependency 'google-protobuf', '~> 4.30.0'
  spec.add_dependency 'heredity', '~> 0.1.2'
  spec.add_dependency 'mongoid', '~> 9.0.0'
  spec.add_dependency 'protobuf', '~> 3.10.0'
  spec.add_dependency 'securerandom', '~> 0.4.1'

  ##
  # Ruby version requirement
  #
  spec.required_ruby_version = '>= 3.2.2'

  ##
  # Development dependencies
  #
  spec.add_development_dependency 'pry', '~> 0.15.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency "timecop", "~> 0.9.0"
end
