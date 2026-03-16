require "test_helper"

class TechCategoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get tech_categories_index_url
    assert_response :success
  end
end
