require 'test_helper'

module BcmsBlog
  class BlogsControllerTest < ActionController::TestCase
  
    def setup
      setup_blog_stubs
      Cms::ContentType.create!(:name => 'BcmsBlog::Blog', :group_name => 'Blog')
      create(:blog)
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
      assert_select "p", "Sorry, this section is restricted to administrators."
    end
  end
end