require File.dirname(__FILE__) + "/../test_helper"

class BlogTest < ActiveSupport::TestCase
  
  def test_editable_by
    @group = Factory(:group, :group_type => Factory(:group_type, :name => "CMS User", :cms_access => true))
    @user = Factory.create(:user, :groups => [@group])
    @editable = Factory.create(:blog, :groups => [@group])
    @non_editable = Factory.create(:blog)
    
    assert_equal [@editable], Blog.editable_by(@user)
  end
  
end
