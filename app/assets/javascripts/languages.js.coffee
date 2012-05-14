###*
@namespace scoping into the hquery namespace
###
this.hQuery ||= {}


# =require core.coffee
###*
@class 
@augments hQuery.CodedEntry
@exports Language as hQuery.Language
###
class hQuery.Language extends hQuery.CodedEntry
  constructor: (@json) ->
    super(@json)
  
  ###*
  @returns {hQuery.CodedValue}
  ###
  modeCode: -> new hQuery.CodedValue @json['modeCode']['code'], @json['modeCode']['codeSystem']
  
  ###*
  @returns {String}
  ###
  preferenceIndicator: -> @json['preferenceIndicator']

    
    
    