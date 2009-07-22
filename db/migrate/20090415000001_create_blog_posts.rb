class CreateBlogPosts < ActiveRecord::Migration
  def self.up
    create_versioned_table :blog_posts do |t|
      t.integer :blog_id
      t.integer :author_id
      t.integer :category_id
      t.string :name 
      t.string :slug
      t.text :summary 
      t.text :body, :size => (64.kilobytes + 1)
      t.integer :comments_count
      t.datetime :published_at
    end
    CategoryType.create!(:name => "Blog Post")
    ContentType.create!(:name => "BlogPost", :group_name => "Blog")
    
    blog_post_page = Page.create!(
      :name => "Blog Post", 
      :path => "/blog/post", 
      :section => Section.root.first,
      :template_file_name => "default.html.erb")
    
    PagePartial.create!(
      :name => "_blog_post",
      :format => "html",
      :handler => "erb",
      :body => File.read(RAILS_ROOT + "/app/views/portlets/blog_post/_blog_post.html.erb"))
    
    BlogPostPortlet.create!(
      :name => "Blog Post Portlet",
      :template => BlogPostPortlet.default_template,
      :connect_to_page_id => blog_post_page.id,
      :connect_to_container => "main",
      :publish_on_save => true)
      
    route = blog_post_page.page_routes.build(
      :name => "Blog Post",
      :pattern => "/articles/:year/:month/:day/:slug",
      :code => "@blog_post = BlogPost.published_on(params).with_slug(params[:slug]).first")
    route.add_condition(:method, "get")
    route.add_requirement(:year, '\d{4,}')
    route.add_requirement(:month, '\d{2,}')
    route.add_requirement(:day, '\d{2,}')
    route.save!
  end

  def self.down
    ContentType.delete_all(['name = ?', 'BlogPost'])
    CategoryType.all(:conditions => ['name = ?', 'Blog Post']).each(&:destroy)
    drop_table :blog_post_versions
    drop_table :blog_posts
  end
end
