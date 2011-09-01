###*
@namespace scoping into the hquery namespace
###
this.hQuery ||= {}

###*
Converts a a number in UTC Seconds since the epoch to a date.
@param {number} utcSeconds seconds since the epoch in UTC
@returns {Date}
@function
@exports dateFromUtcSeconds as hQuery.dateFromUtcSeconds
###
hQuery.dateFromUtcSeconds = (utcSeconds) ->
  new Date utcSeconds * 1000

###*
@class Scalar - a representation of a unit and value
@exports Scalar as hQuery.Scalar
###
class hQuery.Scalar
  constructor: (@json) ->
  unit: -> @json['unit']
  value: -> @json['value']

###*
@class A code with its corresponding code system
@exports CodedValue as hQuery.CodedValue
###
class hQuery.CodedValue
  ###*
  @param {String} c value of the code
  @param {String} csn name of the code system that the code belongs to
  @constructs
  ###
  constructor: (@c, @csn) ->

  ###*
  @returns {String} the code
  ###
  code: -> @c

  ###*
  @returns {String} the code system name
  ###
  codeSystemName: -> @csn

  ###*
  Returns true if the contained code and codeSystemName match a code in the supplied codeSet.
  @param {Object} codeSet a hash with code system names as keys and an array of codes as values
  @returns {boolean}
  ###
  includedIn: (codeSet) ->
    for codeSystemName, codes of codeSet
      if @csn==codeSystemName
        for code in codes
          if code==@c
            return true
    return false

###*
Status as defined by value set 2.16.840.1.113883.5.14,
the ActStatus vocabulary maintained by HL7

@class Status
@augments hQuery.CodedEntry
@exports Status as hQuery.Status
###
class hQuery.Status extends hQuery.CodedValue
  NORMAL = "normal"
  ABORTED = "aborted"
  ACTIVE = "active"
  CANCELLED = "cancelled"
  COMPLETED = "completed"
  HELD = "held"
  NEW = "new"
  SUSPENDED = "suspended"
  NULLIFIED = "nullified"
  OBSOLETE = "obsolete"

  isNormal: -> @c is NORMAL
  isAborted: -> @c is ABORTED
  isActive: -> @c is ACTIVE
  isCancelled: -> @c is CANCELLED
  isCompleted: -> @c is COMPLETED
  isHeld: -> @c is HELD
  isNew: -> @c is NEW
  isSuspended: -> @c is SUSPENDED
  isNullified: -> @c is NULLIFIED
  isObsolete: -> @c is OBSOLETE


###*
@class an Address for a person or organization
@exports Address as hQuery.Address
###
class hQuery.Address
  constructor: (@json) ->
  ###*
  @returns {Array[String]} the street addresses
  ###
  street: -> @json['street']
  ###*
  @returns {String} the city
  ###
  city: -> @json['city']
  ###*
  @returns {String} the State
  ###
  state: -> @json['state']
  ###*
  @returns {String} the postal code
  ###
  postalCode: -> @json['postalCode']


###*
@class An object that describes a means to contact an entity.  This is used to represent
phone numbers, email addresses,  instant messaging accounts etc.
@exports Telecom as hQuery.Telecom
###
class hQuery.Telecom
  constructor: (@json) ->

  ###*
  @returns {String} the type of telecom entry, phone, sms, email ....
  ###
  type: -> @json['type']

  ###*
  @returns {String} the value of the entry -  the actual phone number , email address , ....
  ###
  value: -> @json['value']

  ###*
  @returns {String} the use of the entry. Is it a home, office, .... type of contact
  ###
  use: -> @json['use']

  ###*
  @returns {Boolean} is this a preferred form of contact
  ###
  preferred: -> @json['preferred']


###*
@class an object that describes a person.  includes a persons name, addresses, and contact information
@exports Person as hQuery.Person
###
class hQuery.Person
  constructor: (@json) ->
  ###*
   @returns {String} the given name of the person
  ###
  given: -> @json['first']

  ###*
   @returns {String} the last/family name of the person
  ###
  last: -> @json['last']

  ###*
   @returns {Array} an array of {@link hQuery.Address} objects associated with the patient
  ###
  addresses: ->
    list = []
    if @json['addresses']
      for address in @json['addresses']
        list.push(new hQuery.Address(address))
    list
    
  ###*
  @returns {Array} an array of {@link hQuery.Telecom} objects associated with the person
  ###
  telecoms: ->
    for tel in @json['telecoms']
      new hQuery.Telecom tel


###*
@class an actor is either a person or an organization
@exports Actor as hQuery.Actor
###
class hQuery.Actor
  constructor: (@json) ->
  person: ->
    if @json['person']
      new hQuery.Person @json['person']
  organization: ->
    if @json['organization']
      new hQuery.Organization @json['organization']


###*
@class an Organization
@exports Organization as hQuery.Organization
###
class hQuery.Organization
  constructor: (@json) ->
  
  ###*
  @returns {String} the id for the organization
  ###
  organizationId: -> @json['organizationId']
  
  ###*
  @returns {String} the name of the organization
  ###
  organizationName: -> @json['organizationName']
  
  ###*
  @returns {Array} an array of {@link hQuery.Address} objects associated with the organization
  ###
  addresses: ->
    list = []
    if @json['addresses']
      for address in @json['addresses']
        list.push(new hQuery.Address(address))
    list
    
  ###*
  @returns {Array} an array of {@link hQuery.Telecom} objects associated with the organization
  ###
  telecoms: ->
    for tel in @json['telecoms']
      new hQuery.Telecom tel


###*
@class represents a DateRange in the form of hi and low date values.
@exports DateRange as hQuery.DateRange
###
class hQuery.DateRange
  constructor: (@json) ->
  hi: ->
    if @json['hi']
      hQuery.dateFromUtcSeconds @json['hi']
  low: ->
    hQuery.dateFromUtcSeconds @json['low']

###*
@class Class used to describe an entity that is providing some form of information.  This does not mean that they are
providing any treatment just that they are providing information.
@exports Informant as hQuery.Informant
###
class hQuery.Informant
  constructor: (@json) ->
  ###*
  an array of hQuery.Person objects as points of contact
  @returns {Array}
  ###
  contacts: ->
    for contact in @json['contacts']
      new hQuery.Person contact
  ###*
   @returns {hQuery.Organization} the organization providing the information
  ###
  organization: -> new hQuery.Organization @json['organization']

###*
@class
@exports CodedEntry as hQuery.CodedEntry
###
class hQuery.CodedEntry
  constructor: (@json) ->

  ###*
  Date and time at which the coded entry took place
  @returns {Date}
  ###
  date: -> hQuery.dateFromUtcSeconds @json['time']

  ###*
  An Array of CodedValues which describe what kind of coded entry took place
  @returns {Array}
  ###
  type: -> hQuery.createCodedValues @json['codes']

  ###*
  A free text description of the type of coded entry
  @returns {String}
  ###
  freeTextType: -> @json['description']

  ###*
  Unique identifier for this coded entry
  @returns {String}
  ###
  id: -> @json['id']

  ###*
  Returns true if any of this entry's codes match a code in the supplied codeSet.
  @param {Object} codeSet a hash with code system names as keys and an array of codes as values
  @returns {boolean}
  ###
  includesCodeFrom: (codeSet) ->
    for codedValue in this.type()
      if codedValue.includedIn(codeSet)
        return true
    return false

###*
@class Represents a list of hQuery.CodedEntry instances. Offers utility methods for matching
entries based on codes and date ranges
@exports CodedEntryList as hQuery.CodedEntryList
###
class hQuery.CodedEntryList extends Array
  constructor: ->
    @push arguments...

  ###*
  Return the number of entries that match the
  supplied code set where those entries occur between the supplied time bounds
  @param {Object} codeSet a hash with code system names as keys and an array of codes as values
  @param {Date} start the start of the period during which the entry must occur, a null value will match all times
  @param {Date} end the end of the period during which the entry must occur, a null value will match all times
  @return {int} the count of matching entries
  ###
  match: (codeSet, start, end) ->
    matchingEntries = 0
    for entry in this
      afterStart = (!start || entry.date()>=start)
      beforeEnd = (!end || entry.date()<=end)
      if (afterStart && beforeEnd && entry.includesCodeFrom(codeSet))
        matchingEntries++;
    matchingEntries


###*
@private
@function

###
hQuery.createCodedValues = (jsonCodes) ->
  codedValues = []
  for codeSystem, codes of jsonCodes
    for code in codes
      codedValues.push new hQuery.CodedValue code, codeSystem
  codedValues


