require_relative '../src/application'
require 'minitest/autorun'
require 'minitest/hyper'

class EnrollCornerCasesTest < Minitest::Test
  def test_fail_enroll_into_civil_department
    application = Application.new
    30.times.each { |i| application.enroll("arjun_#{i}", 'CIVIL') }
    assert_match 'Error', application.enroll('das', 'CIVIL'),
                 'There must be "Error " displayed for this case'
  end

  def test_fail_enroll_into_eee_department
    application = Application.new
    30.times.each { |i| application.enroll("arjun_#{i}", 'EEE') }
    assert_match 'Error', application.enroll('das', 'EEE'),
                 'There must be "Error " displayed for this case'
  end

  def test_fail_enroll_into_mech_department
    application = Application.new
    30.times.each { |i| application.enroll("arjun_#{i}", 'MECH') }
    assert_match 'Error', application.enroll('das', 'MECH'),
                 'There must be "Error " displayed for this case'
  end

  def test_fail_enroll_into_cse_department
    application = Application.new
    30.times.each { |i| application.enroll("arjun_#{i}", 'CSE') }
    assert_match 'Error', application.enroll('das', 'CSE'),
                 'There must be "Error " displayed for this case'
  end

  def test_enroll_into_correct_section_when_other_section_is_full
    application = Application.new
    20.times.each { |i| application.enroll("arjun_#{i}", 'MECH') }
    out = application.enroll('arjun', 'MECH').split("\n")
    assert_equal 'You have been allotted section C', out[1], 'Section allocated is incorrect'
  end

  def test_enroll_generates_correct_roll_no
    application = Application.new
    application.enroll("das", 'EEE')
    8.times.each { |i| application.enroll("arjun_#{i}", 'MECH') }
    application.enroll("das", 'EEE')
    out = application.enroll('arjun_8', 'MECH').split("\n")
    assert_equal 'Your roll number is MECHA09', out[2],  'roll number generated is incorrect'
    5.times.each { |i| application.enroll("arjun_0#{i}", 'MECH') }
    out = application.enroll('zzz', 'MECH').split("\n")
    assert_equal 'Your roll number is MECHB05', out[2],  'roll number generated is incorrect'
  end

  def test_enroll_must_reorder_student_roll_no
    application = Application.new
    15.times.each { |i| application.enroll("arjun_#{i}", 'MECH') }
    out = application.enroll('aaa', 'MECH').split("\n")
    assert_equal 'Your roll number is MECHB01', out[2],  'roll number generated is incorrect'
  end
end

class ChangeDeptReorderTest < Minitest::Test
  def test_fail_change_department
    application = Application.new
    30.times.each { |i| application.enroll("arjun_#{i}", 'EEE') }
    application.enroll('das', 'CSE')
    assert_match 'Error', application.change_dept('das', 'EEE')
  end

  def test_fail_for_non_existent_student
    application = Application.new
    assert_match 'Error', application.change_dept('das', 'EEE')
  end

  def test_fail_for_bad_dept
    application = Application.new
    assert_match 'Error', application.change_dept('das', 'EED')
  end
end

class DepartmentViewTest < Minitest::Test
  def test_view_students_in_dept
    application = Application.new
    30.times.each { |i| application.enroll("arjun_#{i}", 'EEE') }
    out2 = application.department_view 'EEE'
    30.times.each { |i| application.enroll("arjun_#{i}", 'CIVIL') }
    out1 = application.department_view 'CIVIL'
    assert_equal "List of students:\narjun_0 - CIVILA01\narjun_1 - CIVILA02\narjun_2 - CIVILA03\narjun_3 - CIVILA04\narjun_4 - CIVILA05\narjun_5 - CIVILA06\narjun_6 - CIVILA07\narjun_7 - CIVILA08\narjun_8 - CIVILA09\narjun_9 - CIVILA10\narjun_10 - CIVILB01\narjun_11 - CIVILB02\narjun_12 - CIVILB03\narjun_13 - CIVILB04\narjun_14 - CIVILB05\narjun_15 - CIVILB06\narjun_16 - CIVILB07\narjun_17 - CIVILB08\narjun_18 - CIVILB09\narjun_19 - CIVILB10\narjun_20 - CIVILC01\narjun_21 - CIVILC02\narjun_22 - CIVILC03\narjun_23 - CIVILC04\narjun_24 - CIVILC05\narjun_25 - CIVILC06\narjun_26 - CIVILC07\narjun_27 - CIVILC08\narjun_28 - CIVILC09\narjun_29 - CIVILC10",
                 out1, 'Department list is incorrect'
    assert_equal "List of students:\narjun_0 - EEEA01\narjun_1 - EEEA02\narjun_2 - EEEA03\narjun_3 - EEEA04\narjun_4 - EEEA05\narjun_5 - EEEA06\narjun_6 - EEEA07\narjun_7 - EEEA08\narjun_8 - EEEA09\narjun_9 - EEEA10\narjun_10 - EEEB01\narjun_11 - EEEB02\narjun_12 - EEEB03\narjun_13 - EEEB04\narjun_14 - EEEB05\narjun_15 - EEEB06\narjun_16 - EEEB07\narjun_17 - EEEB08\narjun_18 - EEEB09\narjun_19 - EEEB10\narjun_20 - EEEC01\narjun_21 - EEEC02\narjun_22 - EEEC03\narjun_23 - EEEC04\narjun_24 - EEEC05\narjun_25 - EEEC06\narjun_26 - EEEC07\narjun_27 - EEEC08\narjun_28 - EEEC09\narjun_29 - EEEC10",
                 out2, 'Department list is incorrect'
  end
end

class SectionViewTest < Minitest::Test
  def test_view_students_in_section
    application = Application.new
    30.times.each { |i| application.enroll("arjun_#{i}", 'CIVIL') }
    out = application.section_view 'CIVIL', 'B'
    assert_equal "List of students:\narjun_10 - CIVILB01\narjun_11 - CIVILB02\narjun_12 - CIVILB03\narjun_13 - CIVILB04\narjun_14 - CIVILB05\narjun_15 - CIVILB06\narjun_16 - CIVILB07\narjun_17 - CIVILB08\narjun_18 - CIVILB09\narjun_19 - CIVILB10",
                 out, 'Department list is incorrect'
  end
end