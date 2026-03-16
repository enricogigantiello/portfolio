require "test_helper"

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get projects_url(locale: :en)
    assert_response :success
  end

  test "should get show" do
    get job_project_url(jobs(:one), projects(:one), locale: :en)
    assert_response :success
  end
end
