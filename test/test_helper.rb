ENV["RAILS_ENV"] = "test"
ENV["BACKTRACE"] = 'YES PLEASE'

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def create_baseline_data
    # Find the seed data items
    @blog = Blog.create!(:name=>"My Blog")
    @blog_page = Page.find_by_path("/")
    @blog_post_page = Page.find_by_path("/blog/post")
    
    @category_type = CategoryType.create!(:name=>"Blog Post")
    
    # For some reason this is necessary otherwise the relevant page routes aren't loaded when
    # the tests are run via "rake" (as opposed to running them directly). I don't know exactly
    # why this is the case.
    # ActionController::Routing::Routes.load!
    PageRoute.reload_routes

    @stuff = Category.create!(:name => "Stuff", :category_type => @category_type)
    @general = Category.create!(:name => "General", :category_type => @category_type)
    
    @first_post = Factory(:blog_post, :blog => @blog, :category => @general,
      :published_at => Time.utc(2008, 7, 5, 6), :publish_on_save => true)
    
    @foo_post_1 = Factory(:blog_post, :blog => @blog, :category => @stuff,
      :published_at => Time.utc(2008, 7, 5, 12), :tag_list => "foo stuff", :publish_on_save => true)
    
    @foo_post_2 = Factory(:blog_post, :blog => @blog, :category => @general,
      :published_at => Time.utc(2008, 7, 21), :publish_on_save => true)
    
    @bar_post_1 = Factory(:blog_post, :blog => @blog, :category => @stuff,
      :published_at => Time.utc(2008, 9, 2), :tag_list => "foo stuff", :publish_on_save => true)
    
    @bar_post_2 = Factory(:blog_post, :blog => @blog, :category => @general,
      :published_at => Time.utc(2009, 3, 18), :publish_on_save => true)
  end
  
  def destroy_baseline_data
    Category.destroy_all
    BlogPost.destroy_all
  end

  def setup_stubs
    PageRoute.stubs(:reload_routes)
    PageRoute.any_instance.stubs(:save!).returns(true)
    @section = Section.new
    Section.stubs(:create! => @section)
    @section.stubs(:groups => [], :save! => true)
    Page.stubs(:create! => Page.new)
    Page.any_instance.stubs(:create_connector)
    
  end
  
  def create_group
   @group = Factory(:group, :name => "Test", :group_type => Factory(:group_type, :name => "CMS User", :cms_access => true))
   @group.permissions << Factory(:permission, :name => "edit_content")
   @group.permissions << Factory(:permission, :name => "publish_content")
  end
  
  def create_user(opts = {})
    create_group
    @group.permissions << Factory(:permission, :name => "administrate") if opts[:admin]
    @user = Factory(:user, :groups => [@group])
  end
  
  def login_as(user)
    @request.session[:user_id] = user ? user.id : nil
  end
end
