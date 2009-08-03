require File.dirname(__FILE__) + '/../../test_helper'

class Cms::BlogsControllerTest < ActionController::TestCase
  def test_list_blog_posts_as_non_admin
    create_non_admin_user
    login_as(@user)
    
    get :index
    assert_response :success
    assert @response.body.include? "Sorry, this section is restricted to administrators."
  end
end
