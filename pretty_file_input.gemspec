$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require 'pretty_file_input/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = 'pretty_file_input'
  s.version = PrettyFileInput::VERSION
  s.required_ruby_version = Gem::Requirement.new('>= 2.0.0')
  s.authors = ['Adam Becker']
  s.summary = 'A more powerful file input.'
  s.email = 'adam@dobt.co'
  s.license = 'MIT'
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {features,spec}/*`.split("\n")
  s.homepage = 'http://github.com/dobtco/pretty_file_input'

  s.add_dependency 'coffee-script'
  s.add_dependency 'erector-rails4'
  s.add_dependency 'sass'

  s.add_development_dependency 'capybara', '2.4.4'
  s.add_development_dependency 'carrierwave'
  s.add_development_dependency 'dvl-core'
  s.add_development_dependency 'rails', '4.1.9'
  s.add_development_dependency 'rspec-rails', '3.1.0'
  s.add_development_dependency 'selenium-webdriver', '2.45.0'
  s.add_development_dependency 'simple_form', '3.1.0'
  s.add_development_dependency 'sqlite3', '1.3.9'
  s.add_development_dependency 'thin', '1.6.3'
end
