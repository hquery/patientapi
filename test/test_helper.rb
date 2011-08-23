require 'bundler/setup'
require 'test/unit'
require 'tilt'
require 'coffee_script'
require 'sprockets'
require 'execjs'

Tilt::CoffeeScriptTemplate.default_bare=true
class QueryExecutor
  @@ctx = nil
  
  def self.ctx 
    unless @@ctx
      @@ctx = Sprockets::Environment.new(File.expand_path("../../", __FILE__))
      @@ctx.append_path "app/assets/javascripts"
    end
    @@ctx
  end

  def self.patient_api_javascript
    self.ctx.find_asset('patient')
  end
  
end