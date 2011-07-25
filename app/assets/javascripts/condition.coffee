###*
@namespace scoping into the hquery namespace
###
this.hQuery ||= {}

# =require core.coffee
###*
@class Provider

  Describes a person/organization that has provided treatment for the given condition. 
  
  The dateRange element describes the last range that the actor provided treatment for the 
  condition.
  
  The provider is represented by the core:actor substitution group which equates to either a 
  person element or and organization element being present.
  @exports Provider as hQuery.Provider 
###
class hQuery.Provider
  constructor: (@json) ->
    ###*
     @returns {hQuery.DateRange} the date range this provider provided treatment
    ###
  effectiveDate: -> new hQuery.DateRange @json['effectiveDate'] 
  ###*
   @returns {hQuery.Actor} the person or organization the provided the treatment
  ###
  actor: -> new hQuery.Actor @json['actor'] 
  ###*
   @returns {hQuery.Informant} the person or organization that is providing the information about this provider
  ###
  informant: -> new hQuery.Informant @json['informant'] 
  ###*
   @returns {String} Free text block
  ###
  narrative: -> @json['narrative']

###*
@class Condition

This section is used to describe a patients problems/conditions. The types of conditions described have been constrained to the SNOMED CT 
Problem Type code set.

The problemDate element is used to define the time during which the condition was last observed/active. 

The problemType element is used to describe the type of problem/condition.

An unbounded number of treating providers for the particular condition can be supplied.

Element names map to the hData CoC profile

narrative element referrs to narrative (human readable) style content. Usually a human readable version of the
encoded content.
@exports Condition as hQuery.Condition 
###  
class hQuery.Condition
  
  ###*
  @param {Object} A hash representing the Condition
  @constructs
  ###
  constructor: (@json) ->

  ###*
  @returns {hQuery.CodedValue} codedvalue of the condition type 
  ### 
  type: -> new hQuery.CodedValue @json['problemType'].codeSystem, @json['problemType'].code 
  
  ###*
   @returns {String} the name of the condition
  ###
  name: -> @json['problemName']
  ###*
   @returns {hQuery.DateRange} the date range of the condition
  ###
  date: -> new hQuery.DateRange(@json['problemDate'])
  ###*
   @returns {hQuery.CodedValue} the coded value information for the condition
  ###
  code: ->  new hQuery.CodedValue @json['problemCode'].codeSystem, @json['problemCode'].code 
  
  ###*
   @returns {Array, hQuery.Provider} an array of providers for the condition
  ###
  providers: ->    
    for  provider in @json['treatingProviders'] 
       new Provider provider 