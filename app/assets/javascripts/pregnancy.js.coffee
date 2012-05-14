###*
@namespace scoping into the hquery namespace
###
this.hQuery ||= {}


# =require core.coffee
###*
This includes information about the patients current and past pregnancy status
The Coded Entry code system should be SNOMED-CT
@class
@augments hQuery.CodedEntry
@exports Pregnancy as hQuery.Pregnancy 
###
class hQuery.Pregnancy extends hQuery.CodedEntry
  constructor: (@json) ->
    super(@json)
  

  ###*
  @returns {String}
  ###
  comment: -> @json['comment']
  