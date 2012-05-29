require 'test_helper'

class BlogTest < ActiveSupport::TestCase
  
  def setup
    setup_blog_stubs
    @blog = create(:blog, :name => 'TestBlog')
  end

  test "creates a valid instance" do
    assert @blog.valid?
  end
  
  test "requires name" do
    assert build(:blog, :name => nil).invalid?
  end
  
  test "should be editable by user" do
    group = create(:group, :group_type  => create(:group_type,:cms_access => true))
    user = create(:user, :groups => [group])
    blog = build(:blog, :groups => [group])
    assert blog.editable_by?(user)
    assert !@blog.editable_by?(user)
  end
  
  test "should be editable by administrators" do
    admin = create(:user)
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
    create(:blog, :name => 'Test')
  end
  
end
