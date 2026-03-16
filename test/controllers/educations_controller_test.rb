require "test_helper"

class EducationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get educations_index_url
    assert_response :success
  end

  test "should get show" do
    get educations_show_url
    assert_response :success
  end
end
