ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'factory_girl'
require 'mocha'

class ActiveSupport::TestCase
  require File.dirname(__FILE__) + '/test_logging'
  include TestLogging  
  include Cms::DataLoader

  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false

  fixtures :all

  def create_baseline_data
    #load_bcms_seed_data
    
    @blog = Blog.create!(:name => "MyBlog")
    @category_type = Factory(:category_type)
    # 
    # # For some reason this is necessary otherwise the relevant page routes aren't loaded when
    # # the tests are run via "rake" (as opposed to running them directly). I don't know exactly
    # # why this is the case.
    # ActionController::Routing::Routes.load!
    # 
    @stuff = Category.create!(:name => "Stuff", :category_type => @category_type)
    @general = Category.create!(:name => "General", :category_type => @category_type)
    # # 
    @first_post = Factory(:blog_post, :blog => @blog, :category => @general,
     :published_at => Time.utc(2008, 7, 5, 6), :publish_on_save => true)
    # 
    # @foo_post_1 = Factory(:blog_post, :blog => @blog, :category => @stuff,
    #   :published_at => Time.utc(2008, 7, 5, 12), :tag_list => "foo stuff", :publish_on_save => true)
    # 
    # @foo_post_2 = Factory(:blog_post, :blog => @blog, :category => @general,
    #   :published_at => Time.utc(2008, 7, 21), :publish_on_save => true)
    # 
    # @bar_post_1 = Factory(:blog_post, :blog => @blog, :category => @stuff,
    #   :published_at => Time.utc(2008, 9, 2), :tag_list => "foo stuff", :publish_on_save => true)
    # 
    # @bar_post_2 = Factory(:blog_post, :blog => @blog, :category => @general,
    #   :published_at => Time.utc(2009, 3, 18), :publish_on_save => true)
  end
  
  # def destroy_baseline_data
  #   Category.destroy_all
  #   BlogPost.destroy_all
  # end

  def setup_stubs
    Blog.any_instance.stubs(:reload_routes)
    @section = Section.new
    Section.stubs(:create! => @section)
    @section.stubs(:groups => [], :save! => true)
    Page.stubs(:create! => Page.new)
    Page.any_instance.stubs(:create_connector)
  end
  
  def login_as(user)
    @request.session[:user_id] = user ? user.id : nil
  end
  
  private
  
  # TODO Find a way to quiet this method's output
  def load_bcms_seed_data
    # `rake db:migrate:up VERSION=20081114172307`
    require File.join(Rails.root, 'db', 'migrate', '20081114172307_load_seed_data.rb')
    LoadSeedData.up
  end
  
  
  # def create_group
  #  @group = Factory(:group, :name => "Test", :group_type => Factory(:group_type, :name => "CMS User", :cms_access => true))
  #  @group.permissions << Factory(:permission, :name => "edit_content")
  #  @group.permissions << Factory(:permission, :name => "publish_content")
  # end
  # 
  # def create_user(opts = {})
  #   create_group
  #   @group.permissions << Factory(:permission, :name => "administrate") if opts[:admin]
  #   @user = Factory(:user, :groups => [@group])
  # end
  

  
end
