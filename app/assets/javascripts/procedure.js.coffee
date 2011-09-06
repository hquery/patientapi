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
  @returns {hQuery.Person} The entity that performed the procedure
  ###
  performer: -> new hQuery.Actor @json['performer']