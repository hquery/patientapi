# =require core.js.coffee
# =require medication.js.coffee
# =require condition.js.coffee
# =require encounter.js.coffee
# =require procedure.js.coffee
# =require result.js.coffee
# =require immunization.js.coffee
# =require allergy.js.coffee
# =require provider.js.coffee
# =require languages.js.coffee
# =require pregnancy.js.coffee
# =require socialhistory.js.coffee

###*
@namespace scoping into the hquery namespace
###
this.hQuery ||= {}

###*
@class Supports
@exports Supports as hQuery.Supports
###
class hQuery.Supports
  constructor: (@json) ->
  ###*
  @returns {DateRange}
  ###
  supportDate: -> new hQuery.DateRange @json['supportDate']
    
  ###*
  @returns {Person} 
  ###
  guardian: -> new hQuery.Person @json['guardian']
  
  ###*
  @returns {String}
  ###
  guardianSupportType: -> @json['guardianSupportType']
  
  ###*
  @returns {Person}
  ###
  contact: -> new hQuery.Person @json['contact']
  
  ###*
  @returns {String}
  ###
  contactSupportType: -> @json['guardianSupportType']
  
  
###*
@class Representation of a patient
@augments hQuery.Person
@exports Patient as hQuery.Patient
###
class hQuery.Patient extends hQuery.Person
  ###*
  @returns {String} containing M or F representing the gender of the patient
  ###
  gender: -> @json['gender']

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
  @returns {CodedValue} the domestic partnership status of the patient
  The following HL7 codeset is used:
  A  Annulled
  D  Divorced
  I   Interlocutory
  L  Legally separated
  M  Married
  P  Polygamous
  S  Never Married
  T  Domestic Partner
  W  Widowed
  ###
  maritalStatus: -> 
    if @json['maritalStatus']
      return new hQuery.CodedValue @json['maritalStatus']['code'], @json['maritalStatus']['codeSystem']
  
  ###*
  @returns {CodedValue}  of the spiritual faith affiliation of the patient
  It uses the HL7 codeset.  http://www.hl7.org/memonly/downloads/v3edition.cfm#V32008
  ###
  religiousAffiliation: -> 
    if @json['religiousAffiliation']
      return new hQuery.CodedValue @json['religiousAffiliation']['code'], @json['religiousAffiliation']['codeSystem']
  
  ###*
  @returns {CodedValue}  of the race of the patient
  CDC codes:  http://phinvads.cdc.gov/vads/ViewCodeSystemConcept.action?oid=2.16.840.1.113883.6.238&code=1000-9
  ###
  race: -> 
    if @json['race']
      return new hQuery.CodedValue @json['race']['code'], @json['race']['codeSystem']
  
  ###*
  @returns {CodedValue} of the ethnicity of the patient
  CDC codes:  http://phinvads.cdc.gov/vads/ViewCodeSystemConcept.action?oid=2.16.840.1.113883.6.238&code=1000-9
  ###
  ethnicity: -> 
    if @json['ethnicity']
      return new hQuery.CodedValue @json['ethnicity']['code'], @json['ethnicity']['codeSystem']
  
  ###*
  @returns {CodedValue} This is the code specifying the level of confidentiality of the document.
  HL7 Confidentiality Code (2.16.840.1.113883.5.25)
  ###
  confidentiality: -> 
    if  @json['confidentiality']
      return new hQuery.CodedValue @json['confidentiality']['code'], @json['confidentiality']['codeSystem']
  
  ###*
  @returns {Address} of the location where the patient was born
  ###
  birthPlace: -> 
    new hQuery.Address @json['birthPlace']
  
  ###*
  @returns {Supports} information regarding key support contacts relative to healthcare decisions, including next of kin
  ###
  supports: -> new hQuery.Supports @json['supports']
  
  ###*
  @returns {Organization}
  ###
  custodian: -> new hQuery.Organization @json['custodian']

  ###*
  @returns {Provider}  the providers associated with the patient
  ###
  provider: -> new hQuery.Provider @json['provider']
  
   
  ###*
  @returns {hQuery.CodedEntryList} A list of {@link hQuery.LanguagesSpoken} objects
  Code from http://www.ietf.org/rfc/rfc4646.txt representing the name of the human language
  ###
  languages: ->
    list = new hQuery.CodedEntryList
    if @json['languages']
      for language in @json['languages']
        list.push(new hQuery.Language(language))
    list

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
  immunizations: ->
    list = new hQuery.CodedEntryList
    if @json['immunizations']
      for immunization in @json['immunizations']
        list.push(new hQuery.Immunization(immunization))
    list
    
    
  ###*
  @returns {hQuery.CodedEntryList} A list of {@link Allergy} objects
  ###
  allergies: ->
    list = new hQuery.CodedEntryList
    if @json['allergies']
      for allergy in @json['allergies']
        list.push(new hQuery.Allergy(allergy))
    list

  ###*
  @returns {hQuery.CodedEntryList} A list of {@link Pregnancy} objects
  ###
  pregnancies: ->
    list = new hQuery.CodedEntryList
    if @json['pregnancies']
      for pregnancy in @json['pregnancies']
        list.push(new hQuery.Pregnancy(pregnancy))
    list
    
  ###*
  @returns {hQuery.CodedEntryList} A list of {@link Socialhistory} objects
  ###
  socialHistories: ->
    list = new hQuery.CodedEntryList
    if @json['socialhistories']
      for socialhistory in @json['socialhistories']
        list.push(new hQuery.Socialhistory(socialhistory))
    list


