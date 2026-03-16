require "test_helper"

class EducationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get educations_url(locale: :en)
    assert_response :success
  end

  test "should get show" do
    get education_url(educations(:one), locale: :en)
    assert_response :success
  end
end
