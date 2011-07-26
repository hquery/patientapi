require File.expand_path("../../test_helper", __FILE__)

class PatientApiTest  < Test::Unit::TestCase
  def setup
    patient_api = QueryExecutor.patient_api_javascript.to_s
    fixture_json = File.read('test/fixtures/patient/barry_berry.json')
    initialize_patient = 'var patient = new hQuery.Patient(barry);'
    date = Time.new(2010,1,1)
    initialize_date = "var sampleDate = new Date(#{date.to_i*1000});"
    @context = ExecJS.compile(patient_api + "\n" + fixture_json + "\n" + initialize_patient + "\n" + initialize_date)
  end
  
  def test_demographics
    assert_equal 'Barry', @context.eval('patient.given()')
    assert_equal 1962, @context.eval('patient.birthtime().getFullYear()')
    assert_equal 'M', @context.eval('patient.gender()')
    assert_equal 48, @context.eval('patient.age()').to_i
  end
  
  def test_encounters
    assert_equal 2, @context.eval('patient.encounters().length')
    assert_equal '99201', @context.eval('patient.encounters()[0].type()[0].code()')
    assert_equal 'CPT', @context.eval('patient.encounters()[0].type()[0].codeSystemName()')
    assert @context.eval('patient.encounters()[0].includesCodeFrom({"RxNorm": ["1","2"], "CPT": ["44388", "99201"]})')
  end
  
  def test_procedures
    assert_equal 1, @context.eval('patient.procedures().length')
    assert_equal '44388', @context.eval('patient.procedures()[0].type()[0].code()')
    assert_equal 'CPT', @context.eval('patient.procedures()[0].type()[0].codeSystemName()')
    assert_equal 'Colonscopy', @context.eval('patient.procedures()[0].freeTextType()')
    assert @context.eval('patient.procedures()[0].includesCodeFrom({"CPT": ["44388"]})')
    assert_equal 1, @context.eval('patient.countMatchingWithinPeriod(patient.procedures(), {"CPT": ["44388"]})')
    assert_equal 0, @context.eval('patient.countMatchingWithinPeriod(patient.procedures(), {"CPT": ["44388"]}, sampleDate)')
  end
  
  def test_vital_signs
    assert_equal 2, @context.eval('patient.vitalSigns().length')
    assert_equal '105539002', @context.eval('patient.vitalSigns()[0].type()[0].code()')
    assert_equal 'SNOMED-CT', @context.eval('patient.vitalSigns()[0].type()[0].codeSystemName()')
    assert_equal 'completed', @context.eval('patient.vitalSigns()[0].status()')
    assert_equal 132, @context.eval('patient.vitalSigns()[1].value()["scalar"]')
  end
  
  def test_conditions
    assert_equal 2, @context.eval('patient.conditions().length')
  end  
  
  def test_medications
    assert_equal 2, @context.eval('patient.medications().length')
    assert_equal '857924', @context.eval('patient.medications()[0].medicationInformation().codedProduct()[0].code()')
  end
end