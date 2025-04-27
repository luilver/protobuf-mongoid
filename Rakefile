# frozen_string_literal: true

require "rake"
require "bundler/gem_tasks"

# Default task
task default: :spec

# Run tests
desc "Run RSpec tests"
task :spec do
  sh "rspec"
end

# Clean up generated files
desc "Clean up generated files"
task :clean do
  rm_rf "pkg"
end