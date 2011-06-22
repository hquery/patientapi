# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "hquery-patient-api"
  s.summary = "A javascript library abstraction for dealing with patients in hQuery map reduce functions"
  s.description = "A javascript library abstraction for dealing with patients in hQuery map reduce functions"
  s.email = "talk@hquery.org"
  s.homepage = "http://github.com/hquery/patient_api"
  s.authors = ["Marc Hadley", "Andy Gregorowicz", "Rob Dingwell"]
  s.version = '0.1.0'

  s.files = Dir.glob('app/**/**/**') + Dir.glob('lib/**/**/**') + ["README.md","VERSION",'Gemfile']
end

