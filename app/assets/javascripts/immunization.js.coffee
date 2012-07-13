###*
@namespace scoping into the hquery namespace
###
this.hQuery ||= {}

# =require core.coffee
# =require medication.coffee

###*
NoImmunzation as defined by value set 2.16.840.1.113883.1.11.19717
The terms come from Health Level Seven (HL7) Version 3.0 Vocabulary and are managed by HL7
It indicates the reason an immunization was not administered.

@class NoImmunization - describes the status of the medication
@augments hQuery.CodedEntry
@exports NoImmunization as hQuery.NoImmunization
###
class hQuery.NoImmunization extends hQuery.CodedValue
  IMMUNITY = "IMMUNE"
  MED_PRECAUTION = "MEDPREC"
  OUT_OF_STOCK = "OSTOCK"
  PAT_OBJ = "PATOBJ"
  PHIL_OBJ = "PHILISOP"
  REL_OBJ = "RELIG"  
  VAC_EFF = "VACEFF"
  VAC_SAFETY = "VACSAF"

  ###*
  @returns {Boolean}
  ###
  isImmune: -> @c is IMMUNITY

  ###*
  @returns {Boolean}
  ###
  isMedPrec: -> @c is MED_PRECAUTION

  ###*
  @returns {Boolean}
  ###
  isOstock: -> @c is OUT_OF_STOCK

  ###*
  @returns {Boolean}
  ###
  isPatObj: -> @c is PAT_OBJ
	
  ###*
  @returns {Boolean}
  ###
  isPhilisop: -> @c is PHIL_OBJ	
  
  ###*
  @returns {Boolean}
  ###
  isRelig: -> @c is REL_OBJ
  
  ###*
  @returns {Boolean}
  ###
  isVacEff: -> @c is VAC_EFF
  
  ###*
  @returns {Boolean}
  ###
  isVacSaf: -> @c is VAC_SAFETY


###*
@class represents a immunization entry for a patient.
@augments hQuery.CodedEntry
@exports Immunization as hQuery.Immunization
###
class hQuery.Immunization extends hQuery.CodedEntry
  constructor: (@json) ->
    super(@json)
   
  ###*
  @returns{hQuery.Scalar} 
  ###
  medicationSeriesNumber: ->  new hQuery.Scalar @json['medicationSeriesNumber']
  
  ###*
  @returns{hQuery.MedicationInformation}
  ###
  medicationInformation: ->new hQuery.MedicationInformation @json
  
  ###*
  @returns{Date} Date immunization was administered
  ###
  administeredDate: -> dateFromUtcSeconds @json['administeredDate']
  
  ###*
  @returns{hQuery.Actor} Performer of immunization
  ###
  performer:-> new hQuery.Actor @json['performer']
  
  ###*
  @returns {comment} human readable description of event
  ###
  comment: -> @json['comment']
  
  ###*
  @returns {Boolean} whether the immunization has been refused by the patient.
  ###
  refusalInd: -> @json['negationInd']
  
  ###*
  NoImmunzation as defined by value set 2.16.840.1.113883.1.11.19717
  The terms come from Health Level Seven (HL7) Version 3.0 Vocabulary and are managed by HL7
  It indicates the reason an immunization was not administered.
  @returns {hQuery.NoImmunization}   Used to indicate reason an immunization was not administered.
  ###
  refusalReason: -> new hQuery.NoImmunization @json['negationReason']['code'], @json['negationReason']['codeSystem']
 