###*
@namespace scoping into the hquery namespace
###
this.hQuery ||= {}


# =require core.coffee
	
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
  @returns {hQuery.Organization}
  ###
  facility: -> new hQuery.Organization @json['facility']

  ###*
  @returns {hQuery.DateRange}
  ###
  encounterDuration: -> new hQuery.DateRange @json
  
  ###*
  @returns {hQuery.CodedEntry}
  ###
  reasonForVisit: -> new hQuery.CodedEntry @json['reason']
  
