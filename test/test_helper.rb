ENV["RAILS_ENV"] = "test"
ENV['BACKTRACE'] = "YES PLEASE"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

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
      @section = Section.create!(:name => "My Site", :path => "/")
      Group.create!(:name => "Guest", :code => "guest", :sections => [@section])
      @page_template = PageTemplate.create!(:name => "test", :format => "html", :handler => "erb", :body => %q{<html>
      <head>
        <title>
          <%= page_title %>
        </title>
        <%= yield :html_head %>
      </head>
      <body>
        <%= cms_toolbar %>
        <%= container :main %>
      </body>
    </html>})

      @blog_page = Page.create!(:name => "My Blog Page", :section => @section, :path => "/", :template_file_name => "test.html.erb")
      @blog_post_page = Page.create!(:name => "Blog Post Page", :section => @section, :path => "/blog/post", :template_file_name => "test.html.erb")

      @blog_posts_with_tag_route = @blog_page.page_routes.create(
        :name => "Blog Posts With Tag",
        :pattern => "/articles/tag/:tag")

      @blog_posts_in_category_route = @blog_page.page_routes.create(
        :name => "Blog Posts In Category", 
        :pattern => "/articles/category/:category")    

      @blog_post_route = @blog_post_page.page_routes.build(
        :name => "Blog Post",
        :pattern => "/articles/:year/:month/:day/:slug",
        :code => "@blog_post = BlogPost.published_on(params).with_slug(params[:slug]).first")
      @blog_post_route.add_condition(:method, "get")
      @blog_post_route.add_requirement(:year, '\d{4,}')
      @blog_post_route.add_requirement(:month, '\d{2,}')
      @blog_post_route.add_requirement(:day, '\d{2,}')
      @blog_post_route.save!    

      @blog_page.publish!
      @blog_post_page.publish!

      @category_type = CategoryType.create!(:name => "Blog Post")
      @stuff = Category.create!(:name => "Stuff", :category_type => @category_type)
      @general = Category.create!(:name => "General", :category_type => @category_type)

      @blog = Blog.create!(
        :name => "My Blog",
        :template => Blog.default_template,
        :connect_to_page_id => @blog_page.id,
        :connect_to_container => "main",
        :publish_on_save => true)

      @first_post = BlogPost.create!(
        :name => "First Post",
        :blog => @blog,
        :category => @general,
        :summary => "This is the first post",
        :body => "Yadda Yadda Yadda",
        :publish_on_save => true)

      @foo_post_1 = BlogPost.create!(
        :name => "Foo #1",
        :blog => @blog,
        :category => @stuff,
        :tag_list => "foo stuff",
        :summary => "This is the first foo post",
        :body => "Foo 1 Foo 1 Foo 1",
        :publish_on_save => true)

      @foo_post_2 = BlogPost.create!(
        :name => "Foo #2",
        :blog => @blog,
        :category => @general,
        :tag_list => "foo",
        :summary => "This is the second foo post",
        :body => "Foo 2 Foo 2 Foo 2",
        :publish_on_save => true)

      @bar_post_1 = BlogPost.create!(
        :name => "Bar #1",
        :blog => @blog,
        :category => @stuff,
        :tag_list => "bar things",
        :summary => "This is the first bar post",
        :body => "Bar 1 Bar 1 Bar 1",
        :publish_on_save => true)

      @bar_post_2 = BlogPost.create!(
        :name => "Bar #2",
        :blog => @blog,
        :category => @general,
        :tag_list => "bar",
        :summary => "This is the second bar post",
        :body => "Bar 2 Bar 2 Bar 2",
        :publish_on_save => true)
  end
  
end
