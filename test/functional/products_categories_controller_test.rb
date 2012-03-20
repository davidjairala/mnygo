require 'test_helper'

class ProductsCategoriesControllerTest < ActionController::TestCase
  setup do
    @products_category = products_categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create products_category" do
    assert_difference('ProductsCategory.count') do
      post :create, :products_category => @products_category.attributes
    end

    assert_redirected_to products_category_path(assigns(:products_category))
  end

  test "should show products_category" do
    get :show, :id => @products_category.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @products_category.to_param
    assert_response :success
  end

  test "should update products_category" do
    put :update, :id => @products_category.to_param, :products_category => @products_category.attributes
    assert_redirected_to products_category_path(assigns(:products_category))
  end

  test "should destroy products_category" do
    assert_difference('ProductsCategory.count', -1) do
      delete :destroy, :id => @products_category.to_param
    end

    assert_redirected_to products_categories_path
  end
end
