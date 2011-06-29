this.hQuery ||= {}
# =require core.coffee
# =require medication.coffee

###*
This class represents an Immunization entry for a patient.  
@class 
### 
class hQuery.Immunization

  ###*
  @returns{Refusal} indicates whether immunization was refused - boolean
  ###
  refusal: -> @json['refusal']
	
  ###*
  @returns{ MedicationInformation}
  ###
  medicationInformation: ->new hQuery.MedicationInformation @json['medicationInformation']
	
  ###*
  @returns{administeredDate} Date immunization was administered
  ###
  administeredDate: -> dateFromUtcSeconds @json['administeredDate']
	
  ###*
  @returns{Person,Organization} performing provider  administering immunization
  ###
  performer:-> new hQuery.Actor @json['performer']
	 
  ###*
  @returns{informant} actor informing immunization
  ###
  informant:-> new hQuery.Informant @json['informant']
	 
  ###*
  @returns{narrative} human readable description of event
  ###
  narrative: -> @json['narrative']
	 
	 
 