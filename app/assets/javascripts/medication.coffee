###*
@namespace scoping into the hquery namespace
###
this.hQuery ||= {}


# =require core.coffee
###*
@class MedicationInformation
@exports MedicationInformation as hQuery.MedicationInformation
###
class hQuery.MedicationInformation 
  constructor: (@json) ->

  ###*
  An array of hQuery.CodedValue describing the medication
  @returns {Array}
  ####
  codedProduct: -> hQuery.createCodedValues @json['codes']
  freeTextProductName: -> @json['description']
  codedBrandName: -> @json['codedBrandName']
  freeTextBrandName: -> @json['brandName']
  drugManufacturer: -> 
    if(@json['drugManufacturer']) 
      new hQuery.Organization(@json['drugManufacturer'])

###*
@class AdministrationTiming - the 
@exports AdministrationTiming as hQuery.AdministrationTiming
###
class hQuery.AdministrationTiming
  constructor: (@json) ->

  ###*
  Provides the period of medication administration as a Scalar. An example
  Scalar that would be returned would be with value = 8 and units = 8. This would
  mean that the medication should be taken every 8 hours.
  @returns {hQuery.Scalar}
  ###
  period: -> new hQuery.Scalar @json['period']

###*
@class DoseRestriction -  restrictions on the medications dose, represented by a upper and lower dose
@exports DoseRestriction as hQuery.DoseRestriction
###
class hQuery.DoseRestriction
  constructor: (@json) ->
  numerator: -> new hQuery.Scalar @json['numerator']
  denominator: -> new hQuery.Scalar @json['denominator']
  

###*
@class FulFillment -  Thie information about when and who fulfilled an order for the medication
@exports FulFillment as hQuery.Fullfilement
###
class hQuery.FulFillment
 constructor: (@json) ->

 dispenseDate: -> hQuery.dateFromUtcSeconds @json['dispenseDate']

 provider:-> new hQuery.Actor @json['provider']

 quantity: -> new hQuery.Scalar @json['quantity']

 prescriptionNumber: -> @json['prescriptionNumber']

 repeatNumber: -> @json['repeatNumber']



###*
@class represents a medication entry for a patient.
@augments hQuery.CodedEntry
@exports Medication as hQuery.Medication
### 
class hQuery.Medication  extends hQuery.CodedEntry
  ###*
  @returns {String} 
  ####
  freeTextSig: -> @json['freeTextSig']


  ###*
  The actual or intended start of a medication. Slight deviation from greenCDA for C32 since
  it combines this with medication stop
  @returns {Date}
  ###
  indicateMedicationStart: -> hQuery.dateFromUtcSeconds @json['start_time']
  
  ###*
  The actual or intended stop of a medication. Slight deviation from greenCDA for C32 since
  it combines this with medication start
  @returns {Date}
  ###
  indicateMedicationStop: -> hQuery.dateFromUtcSeconds @json['end_time']

  administrationTiming: -> new hQuery.AdministrationTiming @json['administrationTiming']

  ###*
  @returns {CodedValue}  Contains routeCode or adminstrationUnitCode information.
    Route code shall have a a value drawn from FDA route of adminstration,
    and indicates how the medication is received by the patient.
    See http://www.fda.gov/Drugs/DevelopmentApprovalProcess/UCM070829
    The administration unit code shall have a value drawn from the FDA
    dosage form, source NCI thesaurus and represents the physical form of the
    product as presented to the patient.
    See http://www.fda.gov/Drugs/InformationOnDrugs/ucm142454.htm
  ###
  route: -> new hQuery.CodedValue @json['route'].codeSystem, @json['route'].code 
 
  ###*
  @returns {hQuery.Scalar} the dose 
  ###
  dose: -> new hQuery.Scalar @json['dose']
 
  ###*
  @returns {CodedValue}
  ###
  site: -> new hQuery.CodedValue @json['site'].codeSystem, @json['site'].code 

  doseRestriction: -> new hQuery.DoseRestriction @json['doseRestriction']
  
  ###*
  @returns {CodedValue}
  ###
  productForm: -> new hQuery.CodedValue @json['productForm'].codeSystem, @json['productForm'].code 
 
  ###*
  @returns {CodedValue}
  ###
  deliveryMethod: -> new hQuery.CodedValue @json['deliveryMethod'].codeSystem, @json['deliveryMethod'].code 

  medicationInformation: -> new hQuery.MedicationInformation @json
 
  ###*
  @returns {CodedValue} Indicates whether this is an over the counter or prescription medication
  ###
  medicationType: -> new hQuery.CodedValue @json['medicationType'].codeSystem, @json['medicationType'].code 
 
  ###*
  @returns {CodedValue}   Used to indicate the status of the medication
  ###
  statusOfMedication: -> new hQuery.CodedValue @json['statusOfMedication'].codeSystem, @json['statusOfMedication'].code 
 
  ###*
  @returns {String} free text instructions to the patient
  ###
  patientInstructions: -> @json['patientInstructions']
  
  ###*
  @returns {Person,Organization} either a patient or organization object for who provided the medication prescription
  ###
  provider: -> new hQuery.Actor @json['provider']
 
  ###*
  @return {String} free text narrative
  ###
  narrative: -> @json['narrative']
 
  ###*
  @returns {Array} an array of {@link FulFillment} objects 
  ###
  fulfillmentHistory: -> 
    for order in @json['fulfillmentHistory']
      new hQuery.FulFillment order
