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
  codedProduct: -> hQuery.createCodedValues @json['codedProducts']
  lotNumber: -> @json['lotNumber']
  brandName: -> @json['brandName']
  drugManufacturer: -> 
    if(@json['drugManufacturer']) 
      new hQuery.Organization(@json['drugManufacturer'])
###*
@class Dose - a medications dose information  , unit and value
@exports Dose as hQuery.Dose
###
class hQuery.Dose
  constructor: (@json) ->
  unit: -> @json['unit']
  value: -> @json['value']
  
  
###*
@class DoseRestriction -  restrictions on the medications dose, represented by a upper and lower dose
@exports DoseRestriction as hQuery.DoseRestriction
###
class hQuery.DoseRestriction
  constructor: (@json) ->
  numerator: -> new hQuery.Dose @json['numerator']
  denominator: -> new hQuery.Dose @json['denominator']
  

###*
@class FulFillment -  Thie information about when and who fulfilled an order for the medication
@exports FulFillment as hQuery.Fullfilement
###
class hQuery.FulFillment
 constructor: (@json) ->

 dispenseDate: -> hQuery.dateFromUtcSeconds @json['dispenseDate']

 provider:-> new hQuery.Actor @json['provider']

 quantity: -> new hQuery.Dose @json['quantity']

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
  @returns {Dose} the dose 
  ###
  dose: -> new hQuery.Dose @json['dose']
 
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

  medicationInformation: -> new hQuery.MedicationInformation @json['medicationInformation']
 
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
