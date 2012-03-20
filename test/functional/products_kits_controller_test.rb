require 'test_helper'

class ProductsKitsControllerTest < ActionController::TestCase
  setup do
    @products_kit = products_kits(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products_kits)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create products_kit" do
    assert_difference('ProductsKit.count') do
      post :create, :products_kit => @products_kit.attributes
    end

    assert_redirected_to products_kit_path(assigns(:products_kit))
  end

  test "should show products_kit" do
    get :show, :id => @products_kit.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @products_kit.to_param
    assert_response :success
  end

  test "should update products_kit" do
    put :update, :id => @products_kit.to_param, :products_kit => @products_kit.attributes
    assert_redirected_to products_kit_path(assigns(:products_kit))
  end

  test "should destroy products_kit" do
    assert_difference('ProductsKit.count', -1) do
      delete :destroy, :id => @products_kit.to_param
    end

    assert_redirected_to products_kits_path
  end
end
