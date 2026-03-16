require "test_helper"

class TechsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get techs_index_url
    assert_response :success
  end
end
