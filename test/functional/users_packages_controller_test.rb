require 'test_helper'

class UsersPackagesControllerTest < ActionController::TestCase
  setup do
    @users_package = users_packages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users_packages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create users_package" do
    assert_difference('UsersPackage.count') do
      post :create, :users_package => @users_package.attributes
    end

    assert_redirected_to users_package_path(assigns(:users_package))
  end

  test "should show users_package" do
    get :show, :id => @users_package.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @users_package.to_param
    assert_response :success
  end

  test "should update users_package" do
    put :update, :id => @users_package.to_param, :users_package => @users_package.attributes
    assert_redirected_to users_package_path(assigns(:users_package))
  end

  test "should destroy users_package" do
    assert_difference('UsersPackage.count', -1) do
      delete :destroy, :id => @users_package.to_param
    end

    assert_redirected_to users_packages_path
  end
end
