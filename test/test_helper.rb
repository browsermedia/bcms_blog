ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'factory_girl'
require 'mocha'
require 'test_logging'

class ActiveSupport::TestCase

  include Bcms::TestSupport
  include TestLogging

  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false

  def create_baseline_data
    @blog = Blog.create!(:name => "MyBlog", :template => %q[<% page_title @page_title || @blog.name %><%= render :partial => "partials/blog_post", :collection => @blog_posts %>"])
    @blog.publish

    @category_type = CategoryType.find_by_name("Blog Post")

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
    
    Page.all.each(&:publish)
  end

  def setup_blog_stubs
    Blog.any_instance.stubs(:reload_routes)
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
end
