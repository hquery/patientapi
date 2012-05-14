###*
@namespace scoping into the hquery namespace
###
this.hQuery ||= {}

# =require core.coffee

###*
@class 
@augments hQuery.CodedEntry
@exports Allergy as hQuery.Allergy
###
class hQuery.Allergy  extends hQuery.CodedEntry
  constructor: (@json) ->
    super(@json)
    
  ###*
  Food and substance allergies use the Unique Ingredient Identifier(UNII) from the FDA
  http://www.fda.gov/ForIndustry/DataStandards/StructuredProductLabeling/ucm162523.htm
  
  Allegies to a class of medication Shall contain a value descending from the NDF-RT concept types 
  of Mechanism of Action - N0000000223, Physiologic Effect - N0000009802 or 
  Chemical Structure - N0000000002. NUI will be used as the concept code. 
  For more information, please see the Web Site 
  http://www.cancer.gov/cancertopics/terminologyresources/page5
  
  Allergies to a specific medication shall use RxNorm for the values.  
  @returns {CodedValue}
  ###
  product: -> this.type()

  ###*
  Date of allergy or adverse event
  @returns{Date}
  ###
  adverseEventDate: -> dateFromUtcSeconds @json['adverseEventDate']

  ###*
  Adverse event types SHALL be coded as specified in HITSP/C80 Section 2.2.3.4.2 Allergy/Adverse Event Type
  @returns {CodedValue}
  ###
  adverseEventType: -> new hQuery.CodedValue @json['type']['code'], @json['type']['codeSystem']

  ###*
  This indicates the reaction that may be caused by the product or agent.  
   It is defined by 2.16.840.1.113883.3.88.12.3221.6.2 and are SNOMED-CT codes.
  420134006   Propensity to adverse reactions (disorder)
  418038007   Propensity to adverse reactions to substance (disorder)
  419511003   Propensity to adverse reactions to drug (disorder)
  418471000   Propensity to adverse reactions to food (disorder)
  419199007  Allergy to substance (disorder)
  416098002  Drug allergy (disorder)
  414285001  Food allergy (disorder)
  59037007  Drug intolerance (disorder)
  235719002  Food intolerance (disorder)
  @returns {CodedValue} 
  ###
  reaction: -> new hQuery.CodedValue @json['reaction']['code'], @json['reaction']['codeSystem']

  ###*
  This is a description of the level of the severity of the allergy or intolerance.
  Use SNOMED-CT Codes as defined by 2.16.840.1.113883.3.88.12.3221.6.8
    255604002  Mild
    371923003  Mild to Moderate
    6736007      Moderate
    371924009  Moderate to Severe
    24484000    Severe
    399166001  Fatal
  @returns {CodedValue} 
  ###
  severity: -> new hQuery.CodedValue @json['severity']['code'], @json['severity']['codeSystem']

  ###*
  Additional comment or textual information
  @returns {String}
  ###
  comment: -> @json['comment']

  