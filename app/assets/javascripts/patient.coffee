# =require core.coffee
# =require medication.coffee
# =require condition.coffee
# =require encounter.coffee
# =require procedure.coffee
# =require result.coffee
###*
@namespace scoping into the hquery namespace
###
this.hQuery ||= {}


###*
@class Representation of a patient
@exports Patient as hQuery.Patient
###
class hQuery.Patient
  ###*
  @constructs
  ###
  constructor: (@json) ->

  ###*
  @returns {String} containing M or F representing the gender of the patient
  ###
  gender: -> @json['gender']

  ###*
  @returns {String} containing the patient's given name
  ###
  given: -> @json['first']

  ###*
  @returns {String} containing the patient's family name
  ###
  family: -> @json['last']

  ###*
  @returns {Date} containing the patient's birthdate
  ###
  birthtime: ->
    hQuery.dateFromUtcSeconds @json['birthdate']
    
  ###*
  @param (Date) date the date at which the patient age is calculated, defaults to now.
  @returns {number} the patient age in years
  ###
  age: (date = new Date()) ->
    oneDay = 24*60*60*1000;
    oneYear = 365*oneDay;
    return (date.getTime()-this.birthtime().getTime())/oneYear;

  ###*
  @returns {Array} A list of {@link hQuery.Encounter} objects
  ###
  encounters: ->
    if @json['encounters']
      for encounter in @json['encounters']
        new hQuery.Encounter encounter
    else
      []
    
  ###*
  @returns {Array} A list of {@link Medication} objects
  ###
  medications: ->
    for medication in @json['medications']
      new hQuery.Medication medication
      
      
  ###*
  @returns {Array} A list of {@link Condition} objects
  ###
  conditions: ->
    for condition in @json['conditions']
      new hQuery.Condition condition

  ###*
  @returns {Array} A list of {@link Procedure} objects
  ###
  procedures: ->
    for procedure in @json['procedures']
      new hQuery.Procedure procedure
      
  ###*
  @returns {Array} A list of {@link Result} objects
  ###
  results: ->
    for result in @json['results']
      new hQuery.Result result

  ###*
  @returns {Array} A list of {@link Result} objects
  ###
  vitalSigns: ->
    for vital in @json['vital_signs']
      new hQuery.Result vital
      
  ###*      
  @returns {Array} A list of {@link Immunization} objects
  ###
  ###*
  immunization: ->
    for immunization in @json['immunization']
      new hQuery.immunization
  ### 
