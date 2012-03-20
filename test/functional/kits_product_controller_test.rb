require 'test_helper'

class KitsProductControllerTest < ActionController::TestCase
  test "should get product_kit_id:integer" do
    get :product_kit_id:integer
    assert_response :success
  end

  test "should get product_id:integer" do
    get :product_id:integer
    assert_response :success
  end

end
