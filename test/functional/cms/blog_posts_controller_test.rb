require File.dirname(__FILE__) + '/../../test_helper'

class Cms::BlogPostsControllerTest < ActionController::TestCase
  def setup
    create_non_admin_user
    login_as(@user)
  end

  def test_access_denied_if_blog_not_user_editable
    @editable = Factory.create(:blog, :groups => [@group])
    @non_editable = Factory.create(:blog)
    post :create, :blog_post => { :blog_id => @non_editable.id }
    assert @response.body.include?("AccessDenied")
  end
  
  def test_no_access_if_no_editable_blogs
    @blog = Factory.create(:blog)
    post :index
    assert_template "no_access"
  end
end
