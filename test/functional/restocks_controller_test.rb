require 'test_helper'

class RestocksControllerTest < ActionController::TestCase
  setup do
    @restock = restocks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:restocks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create restock" do
    assert_difference('Restock.count') do
      post :create, :restock => @restock.attributes
    end

    assert_redirected_to restock_path(assigns(:restock))
  end

  test "should show restock" do
    get :show, :id => @restock.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @restock.to_param
    assert_response :success
  end

  test "should update restock" do
    put :update, :id => @restock.to_param, :restock => @restock.attributes
    assert_redirected_to restock_path(assigns(:restock))
  end

  test "should destroy restock" do
    assert_difference('Restock.count', -1) do
      delete :destroy, :id => @restock.to_param
    end

    assert_redirected_to restocks_path
  end
end
