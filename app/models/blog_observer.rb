class BlogObserver < ActiveRecord::Observer
  
  def after_create(blog)
    @blog = blog
    create_section_pages_and_routes
  end
  
  def before_update(blog)
    update_section_pages_and_route(blog)
  end
  
  def after_update(blog)
    blog.publish
  end
  
  private
  # A section, two pages, 6 routes and a portlet are created alongside every blog.
  # This structure provides sensible defaults so users can pretty much start adding
  # posts right after creating a blog without having to worry about where to put
  # their blog and portlets.
  def create_section_pages_and_routes
    create_blog_section
    create_blog_block_page
    create_post_portlet_page
    reload_routes
  end

  # Every blog is created within a section with the same name.
  # For example, if you create a blog named 'MyBlog', a section 'MyBlog' will be
  # created. This section will hold two pages: one for the blog ContentBlock that
  # will render the list of posts and one for the BlogPost portlet (ie the individual
  # post view)  
  def create_blog_section
    @section = Section.find_by_name(@blog.name) || (
      @section = Section.create!(
        :name => @blog.name,
        :path => "/#{@blog.name_for_path}",
        :parent_id => 1
      )
      @section.groups << Group.find_by_code("cms-admin")
      @section.groups << Group.find_by_code("guest")
      @section.groups << Group.find_by_code("content-editor")
      @section.save!
      @section
    )
  end

  # Following with the above example, the first page that is created is named 'MyBlog' and
  # holds the Blog ContentBlock directly, not a portlet. Together with the 5 created routes,
  # this page and its  ContentBlock handle different post listings (all posts, posts in year, 
  # month or day and posts by tag or category).
  def create_blog_block_page
    page = Page.find_by_name(@blog.name) || Page.create!(
      :name => @blog.name,
      :path => "/#{@blog.name_for_path}",
      :section => @section,
      :template_file_name => "default.html.erb",
      :hidden => true
    )
    page.create_connector(@blog, 'main')

    create_route(page, "#{@blog.name}: Posts In Day",      "/#{@blog.name_for_path}/:year/:month/:day")
    create_route(page, "#{@blog.name}: Posts In Month",    "/#{@blog.name_for_path}/:year/:month")
    create_route(page, "#{@blog.name}: Posts In Year",     "/#{@blog.name_for_path}/:year")
    create_route(page, "#{@blog.name}: Posts With Tag",    "/#{@blog.name_for_path}/tag/:tag")
    create_route(page, "#{@blog.name}: Posts In Category", "/#{@blog.name_for_path}/category/:category")
  end

  # The second page that is created holds the BlogPostPortlet and displays the individual
  # post view, along with it's comments.
  def create_post_portlet_page
    page = Page.find_by_name(portlet_name = "#{@blog.name}: Post") || Page.create!(
      :name => portlet_name,
      :path => "/#{@blog.name_for_path}/post",
      :section => @section,
      :template_file_name => "default.html.erb",
      :hidden => true)
    page.publish
    create_route(page, portlet_name, "/#{@blog.name_for_path}/:year/:month/:day/:slug")
    create_portlet(page, portlet_name, BlogPostPortlet)
  end

  # When the name of a Blog block changes, we need to change the Post page route.
  # We also change the *names* of the section and pages that hold the blog block and 
  # post portlet because presumably, by changing the name of the blog, the intention 
  # was to reflect this name change in breadcrumbs and menus. 
  # 
  # Note that no other routes or paths are updated. This is intentional to be consistent
  # with how BrowserCMS behaves when a Section or Page names change: paths are not
  # updated automatically.
  def update_section_pages_and_route(blog)
    if blog.name_changed?
      old_blog_name = blog.name_was

      Section.find_by_name(old_blog_name).update_attribute(:name, blog.name)
      PageRoute.find_by_name("#{old_blog_name}: Post").update_attribute(:name, "#{blog.name}: Post")

      page = Page.find_by_name("#{old_blog_name}: Post")
      page.update_attribute(:name, "#{blog.name}: Post")
      page.publish

      page = Page.find_by_name(old_blog_name)
      page.update_attribute(:name, blog.name)
      page.publish
    end
  end 

  def reload_routes
     ActionController::Routing::Routes.load!
  end

  def create_route(page, name, pattern)
    route = page.page_routes.build(:name => name, :pattern => pattern, :code => "")
    route.add_condition(:method, "get")
    route.add_requirement(:year,  '\d{4,}') if pattern.include?(":year")
    route.add_requirement(:month, '\d{2,}') if pattern.include?(":month")
    route.add_requirement(:day,   '\d{2,}') if pattern.include?(":day")
    route.send(:create_without_callbacks)
  end

  def create_portlet(page, name, portlet_class)
    portlet_class.create!(
      :name => "#{name} Portlet",
      :blog_id => @blog.id,
      :template => portlet_class.default_template,
      :connect_to_page_id => page.id,
      :connect_to_container => "main",
      :publish_on_save => true)
  end
end





