require File.dirname(__FILE__) + "/../test_helper"

class BlogTest < ActiveSupport::TestCase
  
  def setup
    setup_stubs
    @blog = Factory(:blog, :name => 'TestBlog')
  end

  test "creates a valid instance" do
    assert @blog.valid?
  end
  
  test "requires name" do
    assert Factory.build(:blog, :name => nil).invalid?
  end
  
  test "should be editable by user" do
    group = Factory(:group, :group_type  => Factory(:group_type,:cms_access => true))
    user = Factory(:user, :groups => [group])
    blog = Factory.build(:blog, :groups => [group])
    assert blog.editable_by?(user)
    assert !@blog.editable_by?(user)
  end
  
  test "should be editable by administrators" do
    admin = Factory(:user)
    admin.expects(:able_to?).with(:administrate).returns(true)
    assert @blog.editable_by?(admin)
  end

  test "should create an instance of BlogPostPortlet" do
    BlogPostPortlet.expects(:create!).with(:name => 'Test: Post Portlet',
                                           :blog_id => 2,
                                           :template => BlogPostPortlet.default_template,
                                           :connect_to_page_id => nil,
                                           :connect_to_container => 'main',
                                           :publish_on_save => true).returns(BlogPostPortlet.new)
    Factory(:blog, :name => 'Test')
  end
  
end
