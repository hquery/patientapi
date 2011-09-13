###*
@namespace scoping into the hquery namespace
###
this.hQuery ||= {}


# =require core.coffee
###*
@class 

@exports Provider as hQuery.Provider
###
class hQuery.Provider
  constructor: (@json) ->

  ###*
  @returns {hQuery.Person}
  ###
  providerEntity: -> new hQuery.Person @json['providerEntity']
  
  ###*
  @returns {hQuery.DateRange}
  ###
  careProvisionDateRange: -> new hQuery.DateRange @json['careProvisionDateRange']
      
  ###*
  @returns {hQuery.CodedValue}
  ###
  role: -> new hQuery.CodedValue @json['role']['code'], @json['role']['codeSystem']
  
  ###*
  @returns {String}
  ###
  patientID: -> @json['patientID']
  
  
  ###*
  @returns {hQuery.CodedValue}
  ###
  providerType: -> new hQuery.CodedValue @json['providerType']['code'], @json['providerType']['codeSystem']
    
  
  ###*
  @returns {String}
  ###
  providerID: -> @json['providerID']
    
  ###*
  @returns {hQuery.Organization}
  ###
  organizationName: -> new hQuery.Organization @json
    
    
    
    