module HqueryPatientApi
  class Generator
    @@ctx = nil

    def self.ctx 
      unless @@ctx
        @@ctx = Sprockets::Environment.new(File.expand_path("../../../", __FILE__))
        @@ctx.append_path "app/assets/javascripts"
      end
      @@ctx
    end

    def self.patient_api_javascript
      self.ctx.find_asset('patient')
    end

  end
end