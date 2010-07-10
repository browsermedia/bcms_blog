require File.dirname(__FILE__) + '/../../test_helper'

class Cms::BlogsControllerTest < ActionController::TestCase
  
  def setup
    setup_blog_stubs
    ContentType.create!(:name => 'Blog', :group_name => 'Blog')
    Factory(:blog)
  end
  
  test "should allow access to admin users" do
    login_as(create_user(:admin => true))
    get :index
    assert_response :success
    assert assigns(:blocks)
    assert_template("index")
  end
  
  test "should not allow access to non-admin users" do
    login_as(create_user)
    get :index
    assert_response :success
    assert_template("admin_only.html.erb")    
  end
end
