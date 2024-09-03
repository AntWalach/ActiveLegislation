require "test_helper"

class SignaturesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get signatures_create_url
    assert_response :success
  end
end
