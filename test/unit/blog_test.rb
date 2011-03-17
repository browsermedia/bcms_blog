require 'test_helper'

class BlogTest < ActiveSupport::TestCase
  
  def setup
    setup_stubs
    @blog = Factory(:blog, :name => 'TestBlog')
    # Factory(:blog_post, :blog => @blog) #unpublished post
  end

  test "creates a valid instance" do
    assert @blog.valid?
  end
  
  test "requires name" do
    assert !Factory.build(:blog, :name => nil).valid?
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
  
  test "should create a section with the same name and route" do
    Section.expects(:create!).with(:name => 'Test', :path => '/test', :parent_id => 1).returns(@section)
    Factory(:blog, :name => 'Test')
  end
  
  test "should create a hidden page with the same name in the section with the blog's name" do
    Page.expects(:create!).with(:name => 'Test', 
                                :path => '/test', 
                                :section => @section, 
                                :template_file_name => 'default.html.erb',
                                :hidden => true).returns(Page.new)
    Factory(:blog, :name => 'Test')       
  end
  
  test "should create a page to hold the BlogPostPortlet" do
    Page.expects(:create!).with(:name => 'Test: Post', 
                                :path => '/test/post', 
                                :section => @section, 
                                :template_file_name => 'default.html.erb',
                                :hidden => true).returns(Page.new)
    Factory(:blog, :name => 'Test')  
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
  
  test "should find posts tagged with 'Ruby'" do
    
  end
  
  test "should find posts in category 'Rails'" do
    
  end
  
  test "should find posts published between a given date YY/MM/DD" do
    
  end
  
  test "should find posts published between a given date YY/MM" do
    
  end
  
  test "should find posts published between a given date YY" do
    
  end
  
end
