# frozen_string_literal: true

require 'bundler'
require 'mongoid'
require 'protobuf'
require 'protobuf/mongoid'

# Load Bundler and set up the environment
Bundler.require(:default, :development, :test)

# Load Mongoid configuration
Mongoid.load!(File.expand_path("mongoid.yml", __dir__), :test)

require 'support/models'
require 'support/protobuf/messages.pb'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.order = :random
  Kernel.srand config.seed
end