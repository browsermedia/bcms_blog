class Blog < ActiveRecord::Base
  acts_as_content_block
  
  has_many :posts, :class_name => "BlogPost", :conditions => { :published => true }, :order => "published_at desc"
  has_many :blog_group_memberships
  has_many :groups, :through => :blog_group_memberships

  validates_presence_of :name
  validates_uniqueness_of :name
  
  before_update :update_section_pages_and_route 
  after_update  :publish
  after_create  :create_section_pages_and_routes

  named_scope :editable_by, lambda { |user|
    if user.able_to?(:administrate)
      { }
    else
      { :include => :groups, :conditions => ["groups.id IN (?)", user.group_ids.join(",")] }
    end
  }

  def self.default_template
    template_file = ActionController::Base.view_paths.map do |vp|
      path = vp.to_s.first == "/" ? vp.to_s : File.join(Rails.root, vp.to_s)
      File.join(path, "cms/blogs/render.html.erb")
    end.detect{|f| File.exists? f }
    template_file ? open(template_file){|f| f.read } : ""
  end

  def self.posts_finder(finder, options)
    if options[:tags]
      finder = finder.tagged_with(options[:tags])
    end
    if options[:exclude_tags]
      finder = finder.not_tagged_with(options[:exclude_tags])
    end
    if options[:category] || options[:category_id]
      category_type = CategoryType.named("Blog Post").first
      category = category_type.categories.named(options[:category]).first if options[:category]
      category = category_type.categories. find(options[:category_id])    if options[:category_id]
      finder = finder.in_category(category)
    end
    finder
  end

  def render
    @blog = self
    finder = @blog.posts.published
    finder = Blog.posts_finder(finder, params)

    if params[:year] && params[:month] && params[:day]
      @date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
      finder = posts.published_between(@date, @date + 1.day)
    elsif params[:year] && params[:month]
      @date = Date.new(params[:year].to_i, params[:month].to_i)
      finder = posts.published_between(@date, @date + 1.month)
    elsif params[:year]
      @date = Date.new(params[:year].to_i)
      finder = posts.published_between(@date, @date + 1.year)
    end

    @blog_posts = finder.all(:limit => 25, :order => "published_at desc")
    raise ActiveRecord::RecordNotFound.new("No posts found") if @blog_posts.empty?

    if params[:category]
      @page_title = "#{params[:category]}"
    elsif params[:tag]
      @page_title = "Posts tagged with #{params[:tag]}"
    elsif params[:year] && params[:month] && params[:day]
      @page_title = "Posts from #{@date.to_s(:long)}"
    elsif params[:year] && params[:month]
      @page_title = "Posts from #{Date::MONTHNAMES[@date.month]} #{@date.year}"
    elsif params[:year]
      @page_title = "Posts from #{@date.year}"
    end
  end

  def inline_options
    {:inline => self.template}
  end

  def self.default_order
    "name"
  end

  def editable_by?(user)
    user.able_to?(:administrate) || !(group_ids & user.group_ids).empty?
  end

  def potential_authors
    groups.map(&:users).flatten.uniq
  end

  def name_for_path
    name.to_slug.gsub('-', '_')
  end

  protected
  
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
    @section = Section.find_by_name(name) || (
      @section = Section.create!(
        :name => name,
        :path => "/#{name_for_path}",
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
    page = Page.find_by_name(name) || Page.create!(
      :name => name,
      :path => "/#{name_for_path}",
      :section => @section,
      :template_file_name => "default.html.erb",
      :hidden => true
    )
    page.create_connector(self, 'main')
    
    create_route(page, "#{name}: Posts In Day",      "/#{name_for_path}/:year/:month/:day")
    create_route(page, "#{name}: Posts In Month",    "/#{name_for_path}/:year/:month")
    create_route(page, "#{name}: Posts In Year",     "/#{name_for_path}/:year")
    create_route(page, "#{name}: Posts With Tag",    "/#{name_for_path}/tag/:tag")
    create_route(page, "#{name}: Posts In Category", "/#{name_for_path}/category/:category")
  end
  
  # The second page that is created holds the BlogPostPortlet and displays the individual
  # post view, along with it's comments.
  
  def create_post_portlet_page
    page = Page.find_by_name(portlet_name = "#{name}: Post") || Page.create!(
      :name => portlet_name,
      :path => "/#{name_for_path}/post",
      :section => @section,
      :template_file_name => "default.html.erb",
      :hidden => true)
    page.publish
    create_route(page, portlet_name, "/#{name_for_path}/:year/:month/:day/:slug")
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
  
  def update_section_pages_and_route
    if name_changed?
      old_blog_name = name_was

      Section.find_by_name(old_blog_name).update_attribute(:name, name)
      PageRoute.find_by_name("#{old_blog_name}: Post").update_attribute(:name, "#{name}: Post")
      
      page = Page.find_by_name("#{old_blog_name}: Post")
      page.update_attribute(:name, "#{name}: Post")
      page.publish
      
      page = Page.find_by_name(old_blog_name)
      page.update_attribute(:name, name)
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
      :blog_id => self.id,
      :template => portlet_class.default_template,
      :connect_to_page_id => page.id,
      :connect_to_container => "main",
      :publish_on_save => true)
  end
end
