require 'rake'
require 'rake/testtask'
require 'sprockets'
require 'tilt'

task :default => [:test_units]
$LOAD_PATH << File.expand_path("../test",__FILE__)
desc "Run basic tests"
Rake::TestTask.new("test_units") { |t|
  t.pattern = 'test/unit/*_test.rb'
  t.verbose = true
  t.warning = true
}


namespace :doc do
  task :generate_js do
    ctx = Sprockets::Environment.new(File.expand_path("../", __FILE__))
    Tilt::CoffeeScriptTemplate.default_bare=true 
    ctx.append_path "app/assets/javascripts"
    api = ctx.find_asset('patient')
    
    Dir.mkdir('tmp') unless Dir.exists?( 'tmp')
    
    File.open('tmp/patient.js', 'w+') do |js_file|
      js_file.write api
    end
  end
  
  desc "Generate docs for patient API"
  task :js => :generate_js do
    system 'java -jar ./doc/jsdoc-toolkit/jsrun.jar ./doc/jsdoc-toolkit/app/run.js -t=doc/jsdoc-toolkit/templates/jsdoc -a tmp/patient.js -d=doc/patient-api'
  end
end
