# Available commands:
# Testing the specification:
#   bundle exec rake spec
# Building a gem from source with rake:
#   bundle exec rake package
# Building a gem from source with rubygems:
#   bundle exec gem build dicom.gemspec
# Create html documentation files:
#   bundle exec rake yard

require 'rubygems/package_task'
require 'rspec/core/rake_task'
require 'yard'

# Build gem:
spec = eval(File.read('dicomnet.gemspec'))
Gem::PackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

# RSpec 2:
RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = ["-c", "-f progress", "-r ./spec/spec_helper.rb"]
  t.pattern = 'spec/**/*_spec.rb'
end

# Build documentation (YARD):
YARD::Rake::YardocTask.new do |t|
  t.options += ['--title', "dicomnet #{DICOMNET::VERSION} Documentation"]
end