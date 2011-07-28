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
  @constructor
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
  @returns {hQuery.CodedEntryList} A list of {@link hQuery.Encounter} objects
  ###
  encounters: ->
    list = new hQuery.CodedEntryList
    if @json['encounters']
      for encounter in @json['encounters']
        list.push(new hQuery.Encounter(encounter))
    list
    
  ###*
  @returns {hQuery.CodedEntryList} A list of {@link Medication} objects
  ###
  medications: ->
    list = new hQuery.CodedEntryList
    if @json['medications']
      for medication in @json['medications']
        list.push(new hQuery.Medication(medication))
    list
      
      
  ###*
  @returns {hQuery.CodedEntryList} A list of {@link Condition} objects
  ###
  conditions: ->
    list = new hQuery.CodedEntryList
    if @json['conditions']
      for condition in @json['conditions']
        list.push(new hQuery.Condition(condition))
    list

  ###*
  @returns {hQuery.CodedEntryList} A list of {@link Procedure} objects
  ###
  procedures: ->
    list = new hQuery.CodedEntryList
    if @json['procedures']
      for procedure in @json['procedures']
        list.push(new hQuery.Procedure(procedure))
    list
      
  ###*
  @returns {hQuery.CodedEntryList} A list of {@link Result} objects
  ###
  results: ->
    list = new hQuery.CodedEntryList
    if @json['results']
      for result in @json['results']
        list.push(new hQuery.Result(result))
    list

  ###*
  @returns {hQuery.CodedEntryList} A list of {@link Result} objects
  ###
  vitalSigns: ->
    list = new hQuery.CodedEntryList
    if @json['vital_signs']
      for vital in @json['vital_signs']
        list.push(new hQuery.Result(vital))
    list
  
  ###*      
  @returns {hQuery.CodedEntryList} A list of {@link Immunization} objects
  ###
  ###*
  immunization: ->
    list = new hQuery.CodedEntryList
    if @json['immunization']
      for immunization in @json['immunization']
        list.push(new hQuery.Immunization(immunization))
    list
  ### 
