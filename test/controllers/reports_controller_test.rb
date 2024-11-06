require "test_helper"

class ReportsControllerTest < ActionDispatch::IntegrationTest
  test "should get annual_report" do
    get reports_annual_report_url
    assert_response :success
  end
end
