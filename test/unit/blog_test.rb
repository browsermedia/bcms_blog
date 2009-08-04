require File.dirname(__FILE__) + "/../test_helper"

class BlogTest < ActiveSupport::TestCase
  
  def test_editable_by_user
    @group = Factory(:group, :group_type => Factory(:group_type, :name => "CMS User", :cms_access => true))
    @user = Factory.create(:user, :groups => [@group])
    @editable = Factory.create(:blog, :groups => [@group])
    @non_editable = Factory.create(:blog)
    
    assert_equal [@editable], Blog.editable_by(@user)
    assert @editable.editable_by?(@user)
    assert !@non_editable.editable_by?(@user)
  end
  
  def test_editable_by_administrator
    @user = Factory.create(:user, :groups => [Group.find_by_code("cms-admin")])
    @blog = Factory.create(:blog)
    assert Blog.editable_by(@user).include?(@blog)
    assert @blog.editable_by?(@user)
  end
  
end
