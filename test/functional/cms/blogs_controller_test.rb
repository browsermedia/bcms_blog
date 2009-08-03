require File.dirname(__FILE__) + '/../../test_helper'

class Cms::BlogsControllerTest < ActionController::TestCase
  def test_list_blog_posts_as_non_admin
    @group = Factory(:group, :name => "Test", :group_type => Factory(:group_type, :name => "CMS User", :cms_access => true))
    @group.permissions << Permission.find_by_name("edit_content")
    @group.permissions << Permission.find_by_name("publish_content")
    @group.save!
    
    @user = Factory(:user)
    @user.groups << @group
    @user.save!
    
    login_as(@user)
    
    get :index
    assert_response :success
    assert @response.body.include? "Sorry, this section is restricted to administrators."
  end
  
  private
  
    def login_as(user)
      @request.session[:user_id] = user ? user.id : nil
    end
end
