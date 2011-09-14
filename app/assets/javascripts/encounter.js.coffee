###*
@namespace scoping into the hquery namespace
###
this.hQuery ||= {}


# =require core.coffee

###*
@class ReasonForVisit
@exports ReasonForVisit as hQuery.ReasonForVisit
###
class hQuery.ReasonForVisit
  constructor: (@json) ->

  ###*
  @returns {String}
  ###
  reasonText: -> @json['reasonText']
  
  ###*
  @returns {CodedValue}
  ###
  reasonCode: -> new hQuery.CodedValue @json['reasonCode']['code'], @json['reasonCode']['codeSystem']
   
	
###*
An Encounter is an interaction, regardless of the setting, between a patient and a
practitioner who is vested with primary responsibility for diagnosing, evaluating,
or treating the patient's condition. It may include visits, appointments, as well
as non face-to-face interactions. It is also a contact between a patient and a
practitioner who has primary responsibility for assessing and treating the
patient at a given contact, exercising independent judgment.
@class An Encounter is an interaction, regardless of the setting, between a patient and a
practitioner 
@augments hQuery.CodedEntry
@exports Encounter as hQuery.Encounter 
###
class hQuery.Encounter extends hQuery.CodedEntry
	
  ###*
  @returns {String}
  ####
  dischargeDisp: -> @json['dischargeDisp']
  
  ###*
  @returns {CodedValue}
  ###
  admitType: -> new hQuery.CodedValue @json['admitType']['code'], @json['admitType']['codeSystem']
  
  ###*
  @returns {hQuery.Actor}
  ###
  performer: -> new hQuery.Actor @json['performer']
  
  ###*
  @returns {hQuery.DateRange}
  ###
  encounterDuration: -> new hQuery.DateRange @json
  
  ###*
  @returns {hQuery.ReasonForVisit}
  ###
  reasonForVisit: -> new hQuery.ReasonForVisit @json
  
