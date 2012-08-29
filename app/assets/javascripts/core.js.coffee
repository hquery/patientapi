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
@class PhysicalQuantity - a representation of a physical quantity
@exports PhysicalQuantity as hQuery.PhysicalQuantity
###
class hQuery.PhysicalQuantity
  constructor: (@json) ->
  units: -> @json['units']
  scalar: -> @json['scalar']

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
  postalCode: -> @json['zip']


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
   @returns {String} the display name of the person
  ###
  name: -> 
    if @json['name']
      @json['name']
    else
      @json['first'] + ' ' + @json['last']

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
  organizationName: -> @json['name']
  
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
@class a Facility
@exports Organization as hQuery.Facility
###
class hQuery.Facility extends hQuery.CodedValue
  constructor: (@json) ->
    if @json['code']?
      super @json['code']['code'], @json['code']['codeSystem']

  ###*
  @returns {String} the name of the facility
  ###
  name: -> @json['name']

  ###*
  @returns {Array} an array of {@link hQuery.Address} objects associated with the facility
  ###
  addresses: ->
    list = []
    if @json['addresses']
      for address in @json['addresses']
        list.push(new hQuery.Address(address))
    list

  ###*
  @returns {Array} an array of {@link hQuery.Telecom} objects associated with the facility
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
    if @json['time']
      @_date = hQuery.dateFromUtcSeconds @json['time']
    if @json['start_time']
      @_startDate = hQuery.dateFromUtcSeconds @json['start_time']
    if @json['end_time']
      @_endDate = hQuery.dateFromUtcSeconds @json['end_time']
    @_type = hQuery.createCodedValues @json['codes']
    @_statusCode = @json['status_code']
    @id = @json['_id']
    @_freeTextType = @json['description']

  ###*
  Date and time at which the coded entry took place
  @returns {Date}
  ###
  date: -> @_date

  ###*
  Date and time at which the coded entry started
  @returns {Date}
  ###
  startDate: -> @_startDate

  ###*
  Date and time at which the coded entry ended
  @returns {Date}
  ###
  endDate: -> @_endDate

  ###*
  Tries to find a single point in time for this entry. Will first return date if it is present,
  then fall back to startDate and finally endDate
  @returns {Date}
  ###
  timeStamp: -> @_date || @_startDate || @_endDate

  ###*
  Determines whether the entry specifies a time range or not
  @returns {boolean}
  ###
  isTimeRange: -> @_startDate? && @_endDate?

  ###*
  Determines whether a coded entry contains sufficient information (code and at least 
  one time stamp) to be usable
  @returns {boolean}
  ###
  isUsable: -> @_type.length>0 && (@_date || @_startDate || @_endDate)
  
  ###*
  An Array of CodedValues which describe what kind of coded entry took place
  @returns {Array}
  ###
  type: -> @_type

  ###*
  A free text description of the type of coded entry
  @returns {String}
  ###
  freeTextType: -> @_freeTextType

  ###*
  Status for this coded entry
  @returns {String}
  ###
  status: ->
    if @_statusCode?
      if @_statusCode['HL7 ActStatus']?
        return @_statusCode['HL7 ActStatus'][0]
      else if @_statusCode['SNOMED-CT']?
        switch @_statusCode['SNOMED-CT'][0]
          when '55561003'
            'active'
          when '73425007'
            'inactive'
          when '413322009'
            'resolved'

  ###*
  Status for this coded entry
  @returns {Hash} keys are code systems, values are arrays of codes
  ###
  statusCode: -> @_statusCode

  ###*
  Returns true if any of this entry codes match a code in the supplied codeSet.
  @param {Object} codeSet a hash with code system names as keys and an array of codes as values
  @returns {boolean}
  ###
  includesCodeFrom: (codeSet) ->
    for codedValue in @_type
      if codedValue.includedIn(codeSet)
        return true
    return false

  ###*
  @returns {Boolean} whether the entry was negated
  ###
  negationInd: -> @json['negationInd'] || false
  
  ###*
  Returns the values of the result. This will return an array that contains
  PhysicalQuantity or CodedValue objects depending on the result type.
  @returns {Array} containing either PhysicalQuantity and/or CodedValues
  ###
  values: ->
    values = []
    allValues = @json['values'] || []
    for value in allValues
      if value['scalar']?
        values.push new hQuery.PhysicalQuantity value
      else
        values.push hQuery.createCodedValues values
    values


  ###*
  Indicates the reason an entry was negated.
  @returns {hQuery.CodedValue}   Used to indicate reason an immunization was not administered.
  ###
  negationReason: -> 
    if @json['negationReason'] && @json['negationReason']['code'] && @json['negationReason']['codeSystem']
      new hQuery.CodedValue @json['negationReason']['code'], @json['negationReason']['codeSystem']
    else
      null

###*
@class Represents a list of hQuery.CodedEntry instances. Offers utility methods for matching
entries based on codes and date ranges
@exports CodedEntryList as hQuery.CodedEntryList
###
class hQuery.CodedEntryList extends Array
  constructor: ->
    @push arguments...

  ###*
  Push the supplied entry onto this list if it is usable
  @param {CodedEntry} a coded entry that should be added to the list if it is usable
  ###
  pushIfUsable: (entry) ->
    if entry.isUsable()
      this.push(entry)
  
  ###*
  Return the number of entries that match the
  supplied code set where those entries occur between the supplied time bounds
  @param {Object} codeSet a hash with code system names as keys and an array of codes as values
  @param {Date} start the start of the period during which the entry must occur, a null value will match all times
  @param {Date} end the end of the period during which the entry must occur, a null value will match all times
  @param {boolean} includeNegated whether the returned list of entries should include those that have been negated
  @return {CodedEntryList} the matching entries
  ###
  match: (codeSet, start, end, includeNegated=false) ->
    cloned = new hQuery.CodedEntryList()
    for entry in this
      afterStart = (!start || entry.timeStamp()>=start)
      beforeEnd = (!end || entry.timeStamp()<=end)
      if (afterStart && beforeEnd && entry.includesCodeFrom(codeSet) && (includeNegated || !entry.negationInd()))
        cloned.push(entry)
    cloned

  ###*
  Return a new list of entries that is the result of concatenating the passed in entries with this list
  @return {CodedEntryList} the set of concatenated entries
  ###
  concat: (otherEntries) ->
    cloned = new hQuery.CodedEntryList()
    for entry in this
      cloned.push entry
    for entry in otherEntries
      cloned.push entry
    cloned

  ###*
  Match entries with the specified statuses
  @return {CodedEntryList} the matching entries
  ###
  withStatuses: (statuses, includeUndefined=true) ->
    statuses = statuses.concat([undefined, null]) if includeUndefined
    cloned = new hQuery.CodedEntryList()
    for entry in this
      cloned.push entry if entry.status() in statuses
    cloned

  ###*
  Filter entries based on negation
  @param {Object} codeSet a hash with code system names as keys and an array of codes as values
  @return {CodedEntryList} negated entries
  ###
  withNegation: (codeSet) ->
    cloned = new hQuery.CodedEntryList()
    for entry in this
      cloned.push entry if entry.negationInd() && (!codeSet || (entry.negationReason() && entry.negationReason().includedIn(codeSet)))
    cloned

  ###*
  Filter entries based on negation
  @return {CodedEntryList} non-negated entries
  ###
  withoutNegation: ->
    cloned = new hQuery.CodedEntryList()
    for entry in this
      cloned.push entry if !entry.negationInd()
    cloned

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


