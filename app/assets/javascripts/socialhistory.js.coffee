###*
@namespace scoping into the hquery namespace
###
this.hQuery ||= {}

# =require core.coffee

###*

The Social History Observation is used to define the patient’s occupational, personal (e.g. lifestyle), 
social, and environmental history and health risk factors, as well as administrative data such as 
marital status, race, ethnicity and religious affiliation. The types of conditions
described have been constrained to the SNOMED CT code system using constrained code set, 2.16.840.1.113883.3.88.12.80.60:
229819007   Tobacco use and exposure
256235009   Exercise
160573003   Alcohol Intake
364393001   Nutritional observable
364703007   Employment detail
425400000   Toxic exposure status
363908000   Details of drug misuse behavior
228272008   Health-related behavior
105421008   Educational achievement

note:  Social History is not part of the existing green c32.
@exports Socialhistory as hQuery.Socialhistory 
@augments hQuery.CodedEntry
###  
class hQuery.Socialhistory extends hQuery.CodedEntry
  
  constructor: (@json) ->
       
  ###*
  Value returns the value of the result. This will return an object. The properties of this
  object are dependent on the type of result.
  ###
  value: -> @json['value']
  
   