require File.expand_path("../../test_helper", __FILE__)

class PatientApiTest  < Test::Unit::TestCase
  def setup
    patient_api = QueryExecutor.patient_api_javascript.to_s
    fixture_json = File.read('test/fixtures/patient/barry_berry.json')
    initialize_patient = 'var patient = new hQuery.Patient(barry);'
    date = Time.new(2010,1,1)
    initialize_date = "var sampleDate = new Date(#{date.to_i*1000});"
    @context = ExecJS.compile(patient_api + "\nvar barry = " + fixture_json + ";\n" + initialize_patient + "\n" + initialize_date)
  end

  def test_demographics
    assert_equal 'Barry', @context.eval('patient.given()')
    assert_equal 'Berry', @context.eval('patient.last()')
    assert_equal 'Barry B. Berry', @context.eval('patient.name()')
    assert_equal 1962, @context.eval('patient.birthtime().getFullYear()')
    assert_equal 'M', @context.eval('patient.gender()')
    assert_equal 49, @context.eval('patient.age(new Date(2012,1,10))').to_i
    assert_equal 1, @context.eval('patient.addresses().length').to_i
    assert_equal 'MA', @context.eval('patient.addresses()[0].state()')
    assert_equal 'M', @context.eval('patient.maritalStatus().code()')
    assert_equal '1013', @context.eval('patient.religiousAffiliation().code()')
    assert_equal '2131-1', @context.eval('patient.race().code()')
    assert_equal '2186-5', @context.eval('patient.ethnicity().code()')
    assert_equal 'DC', @context.eval('patient.birthPlace().state()')
    assert_equal 'Washington', @context.eval('patient.birthPlace().city()')
    assert_equal 'N', @context.eval('patient.confidentiality().code()')
    assert_equal 'General Hospital', @context.eval('patient.custodian().organizationName()')
    assert_equal 2005, @context.eval('patient.supports().supportDate().hi().getFullYear()')
    assert_equal 2005, @context.eval('patient.provider().careProvisionDateRange().hi().getFullYear()')
    assert_equal 'Mary', @context.eval('patient.provider().providerEntity().given()')
    assert_equal 'Care', @context.eval('patient.provider().providerEntity().last()')
    assert_equal 'en', @context.eval('patient.languages()[0].type()[0].code()')
  end

  def test_encounters
    assert_equal 2, @context.eval('patient.encounters().length')
    assert_equal '99201', @context.eval('patient.encounters()[0].type()[0].code()')
    assert_equal 'CPT', @context.eval('patient.encounters()[0].type()[0].codeSystemName()')
    assert_equal 'OP12345', @context.eval('patient.encounters()[0].id()')
    assert_equal 'Outpatient encounter', @context.eval('patient.encounters()[0].freeTextType()')
    assert_equal 'Home', @context.eval('patient.encounters()[0].dischargeDisp()')
    assert_equal '04', @context.eval('patient.encounters()[0].admitType().code()')
    assert_equal 'General Hospital', @context.eval('patient.encounters()[0].performer().organization().organizationName()')
    assert_equal 2005, @context.eval('patient.encounters()[0].encounterDuration().low().getFullYear()')
    assert_equal 2011, @context.eval('patient.encounters()[0].encounterDuration().hi().getFullYear()')
    assert_equal 'PCP referred', @context.eval('patient.encounters()[0].reasonForVisit().freeTextType()')
    assert_equal 'CPT', @context.eval('patient.encounters()[0].reasonForVisit().type()[0].codeSystemName()')
  end

  def test_procedures
    assert_equal 1, @context.eval('patient.procedures().length')
    assert_equal '44388', @context.eval('patient.procedures()[0].type()[0].code()')
    assert_equal 'CPT', @context.eval('patient.procedures()[0].type()[0].codeSystemName()')
    assert_equal 'Colonscopy', @context.eval('patient.procedures()[0].freeTextType()')
    assert @context.eval('patient.procedures()[0].includesCodeFrom({"CPT": ["44388"]})')
    assert_equal 1, @context.eval('patient.procedures().match({"CPT": ["44388"]}).length')
    assert_equal 0, @context.eval('patient.procedures().match({"CPT": ["44388"]}, sampleDate).length')
    assert_equal 'SNOMED-CT', @context.eval('patient.procedures()[0].site().codeSystemName()')
    assert_equal '71854001', @context.eval('patient.procedures()[0].site().code()')
    assert_equal 'Bobby', @context.eval('patient.procedures()[0].performer().person().given()')
    assert_equal 'Tables', @context.eval('patient.procedures()[0].performer().person().last()')
  end

  def test_vital_signs
    assert_equal 2, @context.eval('patient.vitalSigns().length')
    assert_equal '105539002', @context.eval('patient.vitalSigns()[0].type()[0].code()')
    assert_equal 'SNOMED-CT', @context.eval('patient.vitalSigns()[0].type()[0].codeSystemName()')
    assert_equal 'completed', @context.eval('patient.vitalSigns()[0].status()')
    assert_equal 132, @context.eval('patient.vitalSigns()[1].value()["scalar"]')
    assert_equal '8480-6', @context.eval('patient.vitalSigns()[1].resultType()[0].code()')
    assert_equal 'BP taken sitting', @context.eval('patient.vitalSigns()[1].comment()')
  end
  
  def test_results
    assert_equal 1, @context.eval('patient.results().length')
    assert_equal '104150001', @context.eval('patient.results()[0].type()[0].code()')
    assert_equal 'SNOMED-CT', @context.eval('patient.results()[0].type()[0].codeSystemName()')
    assert_equal 'SNOMED-CT', @context.eval('patient.results()[0].resultType()[0].codeSystemName()')
    assert_equal 'completed', @context.eval('patient.results()[0].status()')
    assert_equal 'Negative', @context.eval('patient.results()[0].comment()')
  end

  def test_conditions
    assert_equal 2, @context.eval('patient.conditions().length')
    assert @context.eval('patient.conditions().match({"SNOMED-CT": ["105539002"]}).length != 0')
    assert @context.eval('patient.conditions().match({"SNOMED-CT": ["109838007"]}).length != 0')
    assert_equal 20, @context.eval('patient.conditions()[1].ageAtOnset()')
    assert_equal '55561003', @context.eval('patient.conditions()[1].problemStatus().code()')
  end

  def test_medications
    assert_equal 1, @context.eval('patient.medications().length')
    assert_equal 24, @context.eval('patient.medications()[0].administrationTiming().period().value()')
    assert @context.eval('patient.medications()[0].administrationTiming().institutionSpecified()')
    assert_equal 'tablet', @context.eval('patient.medications()[0].dose().unit()')
    assert_equal 'Multivitamin', @context.eval('patient.medications()[0].medicationInformation().freeTextProductName()')
    assert_equal 1, @context.eval('patient.medications().match({"RxNorm": ["89905"]}).length')
    assert_equal 'C38288', @context.eval('patient.medications()[0].route().code()')
    assert_equal 30, @context.eval('patient.medications()[0].fulfillmentHistory()[0].quantityDispensed().value()')
    assert @context.eval('patient.medications()[0].typeOfMedication().isOverTheCounter()')
    assert @context.eval('patient.medications()[0].statusOfMedication().isActive()')
    assert_equal 30, @context.eval('patient.medications()[0].orderInformation()[0].quantityOrdered().value()')
    assert_equal 20, @context.eval('patient.medications()[0].orderInformation()[0].fills()')
  end
  
  def test_immunizations
    assert_equal 2, @context.eval('patient.immunizations().length')
    assert @context.eval('patient.immunizations().match({"CVX": ["03"]}).length != 0')
    assert_equal 'MMR', @context.eval('patient.immunizations()[0].medicationInformation().freeTextProductName()')
    assert_equal 2, @context.eval('patient.immunizations()[0].medicationSeriesNumber().value()')
    assert_equal 'vaccine', @context.eval('patient.immunizations()[0].comment()')
    assert @context.eval('patient.immunizations()[1].refusalReason().isImmune()')
    assert_equal 'FirstName', @context.eval('patient.immunizations()[1].performer().person().given()')
    assert_equal 'LastName', @context.eval('patient.immunizations()[1].performer().person().last()')
    assert_equal 1, @context.eval('patient.immunizations()[1].performer().person().addresses().length')
    assert_equal '100 Bureau Drive', @context.eval('patient.immunizations()[1].performer().person().addresses()[0].street()[0]')
    assert_equal 'Gaithersburg', @context.eval('patient.immunizations()[1].performer().person().addresses()[0].city()')
    assert_equal 'MD', @context.eval('patient.immunizations()[1].performer().person().addresses()[0].state()')
    assert_equal '20899', @context.eval('patient.immunizations()[1].performer().person().addresses()[0].postalCode()')
  end
  
  def test_allergies
    assert_equal 1, @context.eval('patient.allergies().length')
    assert_equal 'Carries Epipen',@context.eval('patient.allergies()[0].comment()')
    assert_equal 1, @context.eval('patient.allergies().match({"SNOMED-CT": ["39579001"]}).length')
    assert_equal 'Anaphalactic reaction to peanuts', @context.eval('patient.allergies()[0].freeTextType()')
    assert_equal '414285001', @context.eval('patient.allergies()[0].reaction().code()')
    assert_equal '371924009', @context.eval('patient.allergies()[0].severity().code()')
  end
  
  def test_pregnancies
    assert_equal 1, @context.eval('patient.pregnancies().length')
    assert_equal 1, @context.eval('patient.pregnancies().match({"SNOMED-CT": ["77386006"]}).length')
  end
  
  def test_socialhistory
    assert_equal 1, @context.eval('patient.socialHistories().length')
    assert_equal 1, @context.eval('patient.socialHistories().match({"SNOMED-CT": ["229819007"]}).length')
  end
  
end