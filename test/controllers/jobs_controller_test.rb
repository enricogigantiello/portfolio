require "test_helper"

class JobsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get jobs_url(locale: :en)
    assert_response :success
  end

  test "should get show" do
    get job_url(jobs(:one), locale: :en)
    assert_response :success
  end
end
