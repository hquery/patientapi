###*
@namespace scoping into the hquery namespace
###
this.hQuery ||= {}


# =require core.coffee
###*
This represents all interventional, surgical, diagnostic, or therapeutic procedures or 
treatments pertinent to the patient.
@class
@augments hQuery.CodedEntry
@exports Procedure as hQuery.Procedure 
###
class hQuery.Procedure extends hQuery.CodedEntry
  ###*
  @returns {hQuery.Actor} The provider that performed the procedure
  ###
  performer: -> new hQuery.Actor @json['performer']
  
  ###*
  @returns {hQuery.CodedValue} A SNOMED code indicating the body site on which the 
  procedure was performed
  ###
  site: -> new hQuery.CodedValue @json['site']['code'], @json['site']['codeSystem']