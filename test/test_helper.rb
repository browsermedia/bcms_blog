ENV["RAILS_ENV"] = "test"
ENV['BACKTRACE'] = "YES PLEASE"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

unless $database_initialized
  $database_initialized = true
  
  # Empty the database and load in the default seed data for browsercms
  # and the blog module
  `rake db:test:purge`
  `rake db:migrate`

  # Publish all pages, as they are drafts after migrating
  Page.find(:all).each(&:publish!)
end

class ActiveSupport::TestCase
  require File.dirname(__FILE__) + '/test_logging'
  include TestLogging  
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  #
  # The only drawback to using transactional fixtures is when you actually 
  # need to test transactions.  Since your test is bracketed by a transaction,
  # any transactions started in your code will be automatically rolled back.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def create_baseline_data
    # Find the seed data items
    @blog = Blog.find_by_name("My Blog")
    @blog_page = Page.find_by_path("/")
    @blog_post_page = Page.find_by_path("/blog/post")
    @category_type = CategoryType.find_by_name("Blog Post")
    
    # For some reason this is necessary otherwise the relevant page routes aren't loaded when
    # the tests are run via "rake" (as opposed to running them directly). I don't know exactly
    # why this is the case.
    ActionController::Routing::Routes.load!

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
  
  def create_non_admin_user
    @group = Factory(:group, :name => "Test", :group_type => Factory(:group_type, :name => "CMS User", :cms_access => true))
    @group.permissions << Permission.find_by_name("edit_content")
    @group.permissions << Permission.find_by_name("publish_content")
    @group.save!
    
    @user = Factory(:user)
    @user.groups << @group
    @user.save!
  end
  
  def login_as(user)
    @request.session[:user_id] = user ? user.id : nil
  end
  
end
