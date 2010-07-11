module BlogTestHelper

  # Seeds all data created by this module's migrations
  def seed_blog_data
    @content_type_group = ContentTypeGroup.create!(:name => "Blog")
    CategoryType.create!(:name => "Blog Post") 
    ContentType.create!(:name  => "Blog", :content_type_group => @content_type_group)
    ContentType.create!(:name  => "BlogPost", :content_type_group => @content_type_group)
    ContentType.create!(:name  => "BlogComment", :content_type_group => @content_type_group)   
  end

  # Creates data specifically used on tests
  def create_test_data
    template = %q[<% page_title @page_title || @blog.name %><%= render :partial => "partials/blog_post", :collection => @blog_posts %>"]
    @blog = Blog.create!(:name => "MyBlog", :template => template)

    @category_type = CategoryType.find_by_name("Blog Post")

    @stuff = Category.create!(:name => "Stuff", :category_type => @category_type)
    @general = Category.create!(:name => "General", :category_type => @category_type)

    opts = {:blog => @blog, :publish_on_save => true}
    @first_post = Factory(:blog_post, opts.merge(:category => @general, :published_at => Time.utc(2008, 7, 5, 6)))
    @foo_post_1 = Factory(:blog_post, opts.merge(:category => @stuff,   :published_at => Time.utc(2008, 7, 5, 12), :tag_list => "foo stuff"))
    @foo_post_2 = Factory(:blog_post, opts.merge(:category => @general, :published_at => Time.utc(2008, 7, 21)))
    @bar_post_1 = Factory(:blog_post, opts.merge(:category => @stuff,   :published_at => Time.utc(2008, 9, 2),     :tag_list => "foo stuff"))
    @bar_post_2 = Factory(:blog_post, opts.merge(:category => @general, :published_at => Time.utc(2009, 3, 18)))

    publish_all_pages
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