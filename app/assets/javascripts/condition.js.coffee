###*
@namespace scoping into the hquery namespace
###
this.hQuery ||= {}

# =require core.coffee


###*
@class CauseOfDeath
@exports CauseOfDeath as hQuery.CauseOfDeath
###
class hQuery.CauseOfDeath
  constructor: (@json) ->

  ###*
  @returns {hQuery.Date}
  ###
  timeOfDeath: -> new hQuery.dateFromUtcSeconds @json['timeOfDeath']

  ###*
  @returns {int}
  ###
  ageAtDeath: -> @json['ageAtDeath']

###*
@class hQuery.Condition

This section is used to describe a patients problems/conditions. The types of conditions
described have been constrained to the SNOMED CT Problem Type code set. An unbounded
number of treating providers for the particular condition can be supplied.
@exports Condition as hQuery.Condition 
@augments hQuery.CodedEntry
###  
class hQuery.Condition extends hQuery.CodedEntry
  
  constructor: (@json) ->
    super(@json)
  
  ###*
   @returns {Array, hQuery.Provider} an array of providers for the condition
  ###
  providers: ->    
    for  provider in @json['treatingProviders'] 
       new Provider provider 
       
  ###*
  Diagnosis Priority
  @returns {int}
  ###
  diagnosisPriority: -> @json['diagnosisPriority']
  
  ###*
  age at onset
  @returns {int}
  ###
  ageAtOnset: -> @json['ageAtOnset']
  
  
  ###*
  cause of death
  @returns {hQuery.CauseOfDeath}
  ###
  causeOfDeath: -> new hQuery.CauseOfDeath @json['causeOfDeath']
  
  ###*
  problem status
  @returns {hQuery.CodedValue}
  ###
  problemStatus: -> new hQuery.CodedValue @json['problemStatus']['code'], @json['problemStatus']['codeSystem']
  
  ###*
  comment
  @returns {String}
  ###
  comment: -> @json['comment']