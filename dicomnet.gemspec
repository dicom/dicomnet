# encoding: UTF-8

require File.expand_path('../lib/dicomnet/general/version', __FILE__)

Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name = 'dicomnet'
  s.version = DICOMNET::VERSION
  s.date = Time.now
  s.summary = "Library for handling DICOM network communication."
  s.require_paths = ['lib']
  s.author = 'Christoffer Lervag'
  s.email = 'chris.lervag@gmail.com'
  s.homepage = 'https://github.com/dicom/dicomnet'
  s.license = 'GPLv3'
  s.description = "DICOM is a standard widely used throughout the world to store and transfer medical image data. This library enables efficient and powerful handling of DICOM in Ruby, to the benefit of any student or professional who would like to use their favorite language to interact with a DICOM network service."
  s.files = Dir["{lib}/**/*", "[A-Z]*"]
  s.rubyforge_project = 'dicom'

  s.required_ruby_version = '>= 1.9.3'

  s.add_development_dependency('bundler', '~> 1.3')
  s.add_development_dependency('dicom', '~> 0.9.5')
  s.add_development_dependency('mocha', '~> 0.13')
  s.add_development_dependency('rake', '~> 0.9.6')
  s.add_development_dependency('redcarpet', '~> 3.0.0')
  s.add_development_dependency('rspec', '~> 2.13')
  s.add_development_dependency('yard', '~> 0.8.5')
end