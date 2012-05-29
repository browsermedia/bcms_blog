module Cms
module BlogTestHelper

  def seed_bcms_data
    silence_stream(STDOUT) do
      load File.expand_path('../../dummy/db/browsercms.seeds.rb', __FILE__) 
    end
  end
  
  def login_as(user)
    @request.session[:user_id] = user ? user.id : nil
  end
      
      
  # Seeds all data created by this module's migrations
  def seed_blog_data
    @content_type_group = ContentTypeGroup.create!(:name => "Blog")
    Cms::CategoryType.create!(:name => "Blog Post") 
    Cms::ContentType.create!(:name  => "Blog", :content_type_group => @content_type_group)
    Cms::ContentType.create!(:name  => "BlogPost", :content_type_group => @content_type_group)
    Cms::ContentType.create!(:name  => "BlogComment", :content_type_group => @content_type_group)   
  end

  # Creates data specifically used on tests
  def create_test_data
    template = %q[<% page_title @page_title || @blog.name %><%= render :partial => "partials/blog_post", :collection => @blog_posts %>"]
    @blog = BcmsBlog::Blog.create!(:name => "MyBlog", :template => template)

    @category_type = CategoryType.find_by_name("Blog Post")

    @stuff = Category.create!(:name => "Stuff", :category_type => @category_type)
    @general = Category.create!(:name => "General", :category_type => @category_type)

    opts = {:blog => @blog, :publish_on_save => true}
    @first_post = FactoryGirl.create(:blog_post, opts.merge(:category => @general, :published_at => Time.utc(2008, 7, 5, 6), :name => "The first Post"))
    @foo_post_1 = FactoryGirl.create(:blog_post, opts.merge(:category => @stuff,   :published_at => Time.utc(2008, 7, 5, 12), :tag_list => "foo stuff"))
    @foo_post_2 = FactoryGirl.create(:blog_post, opts.merge(:category => @general, :published_at => Time.utc(2008, 7, 21)))
    @bar_post_1 = FactoryGirl.create(:blog_post, opts.merge(:category => @stuff,   :published_at => Time.utc(2008, 9, 2),     :tag_list => "foo stuff"))
    @bar_post_2 = FactoryGirl.create(:blog_post, opts.merge(:category => @general, :published_at => Time.utc(2009, 3, 18)))

    publish_all_pages
  end
  
  def publish_all_pages
    Cms::Page.all.each(&:publish)
  end

  def setup_blog_stubs()
    Cms::PageRoute.stubs(:reload_routes)
    @section = Section.new
    Cms::Section.stubs(:create! => @section)
    @section.stubs(:groups => [], :save! => true)
    Cms::Page.stubs(:create! => Page.new)
    Cms::Page.any_instance.stubs(:create_connector)
    Cms::PageRoute.any_instance.stubs(:save!)
  end

  def create_group
    @group = FactoryGirl.create(:group, :name => "Test", :group_type => FactoryGirl.create(:group_type, :name => "CMS User", :cms_access => true))
    @group.permissions << FactoryGirl.create(:permission, :name => "edit_content")
    @group.permissions << FactoryGirl.create(:permission, :name => "publish_content")
  end

  def create_user(opts = {})
    create_group
    @group.permissions << FactoryGirl.create(:permission, :name => "administrate") if opts[:admin]
    @user = FactoryGirl.create(:user, :groups => [@group])
  end
end
end
ActiveSupport::TestCase.send(:include, Cms::BlogTestHelper)
