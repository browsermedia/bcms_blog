require 'test_helper'


class BlogObserverTest < ActiveSupport::TestCase

  def setup
    setup_blog_stubs
    [Section, PageRoute, Page].each {|klass| klass.stubs(:find_by_name)}
    BlogPostPortlet.stubs(:create!)
    @blog = Factory(:blog, :name => 'TestBlog')
  end
  
  test "does not update section, pageroute and pages if name did not change when updated" do
    [Section, PageRoute, Page].each {|klass| klass.expects(:find_by_name).never}
    @blog.toggle!(:moderate_comments)
  end
  
  test "updates section, pageroute and pages if name changed" do
    route = mock('page_route', :update_attribute => true)
    page = mock('page')
    Section.expects(:find_by_name).returns(Section.new)
    PageRoute.expects(:find_by_name).returns(route)
    Page.expects(:find_by_name).twice.returns(page)
    page.expects(:update_attribute).twice.returns(true)
    page.expects(:publish).twice.returns(true)
    
    @blog.update_attribute(:name, "OtherName")
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
end
