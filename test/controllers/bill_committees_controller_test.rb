require "test_helper"

class BillCommitteesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get bill_committees_show_url
    assert_response :success
  end

  test "should get sign" do
    get bill_committees_sign_url
    assert_response :success
  end
end
