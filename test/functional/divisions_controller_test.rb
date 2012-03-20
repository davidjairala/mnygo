require 'test_helper'

class DivisionsControllerTest < ActionController::TestCase
  setup do
    @division = divisions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:divisions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create division" do
    assert_difference('Division.count') do
      post :create, :division => @division.attributes
    end

    assert_redirected_to division_path(assigns(:division))
  end

  test "should show division" do
    get :show, :id => @division.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @division.to_param
    assert_response :success
  end

  test "should update division" do
    put :update, :id => @division.to_param, :division => @division.attributes
    assert_redirected_to division_path(assigns(:division))
  end

  test "should destroy division" do
    assert_difference('Division.count', -1) do
      delete :destroy, :id => @division.to_param
    end

    assert_redirected_to divisions_path
  end
end
