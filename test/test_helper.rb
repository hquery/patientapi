require 'test/unit'
require 'tilt'
require 'sprockets'

Tilt::CoffeeScriptTemplate.default_bare=true
class QueryExecutor
  @@ctx = nil
  def self.ctx 
     unless @@ctx
        @@ctx = Sprockets::Environment.new(File.expand_path("../../", __FILE__))
        @@ctx.paths << "app/assets/javascripts"
      end
      @@ctx
  end

  def self.patient_api_javascript
    
     self.ctx.find_asset('patient')
  end
  
  
end