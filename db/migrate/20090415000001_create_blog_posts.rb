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
    
    blog_section = Section.new(:name => "Blog", :path => "/blog", :parent_id => 1, :hidden => true)
    blog_section.groups << Group.find_by_code("cms-admin")
    blog_section.groups << Group.find_by_code("guest")
    blog_section.groups << Group.find_by_code("content-editor")
    blog_section.save!
    
    create_blog_page("Blog Post",           blog_section, "/articles/:year/:month/:day/:slug")
    create_blog_page("Blog Posts In Day",   blog_section, "/articles/:year/:month/:day")
    create_blog_page("Blog Posts In Month", blog_section, "/articles/:year/:month")
    create_blog_page("Blog Posts In Year",  blog_section, "/articles/:year")
    
    PagePartial.create!(
      :name => "_blog_post",
      :format => "html",
      :handler => "erb",
      :body => <<'HTML'
<div id="blog_post_<%= blog_post.id %>" class="blog_post">
  <h2><%= link_to h(blog_post.name), blog_post_path(blog_post.route_params) %></h2>
  
  <p class="date"><%= blog_post.published_at.to_s(:long) %></p>
  
  <p class="body">
    <%= blog_post.body %>
  </p>
  
  <p class="meta">
    <% unless blog_post.category_id.blank? %>
      Posted in <%= link_to h(blog_post.category_name), blog_posts_in_category_path(:category => blog_post.category_name) %>
      <strong>|</strong>
    <% end %>
    Tags 
    <span class="tags">
      <%= blog_post.tags.map{|t| link_to(h(t.name), blog_posts_with_tag_path(:tag => t.name)) }.join(", ") %>
    </span>
    <strong>|</strong>
    
    <%= link_to h(pluralize(blog_post.comments_count, "Comment")), "#{blog_post_path(blog_post.route_params)}#comments" %>
  </p>
</div>
HTML
)
  end
  
  def self.create_blog_page(name, section, path)
    page = Page.create!(
      :name => name, 
      :path => name.gsub(" ", "").underscore.downcase.sub("blog_", "/blog/"),
      :section => section,
      :template_file_name => "default.html.erb",
      :hidden => true)
    
    route = page.page_routes.build(:name => name, :pattern => path, :code => "")
    route.add_condition(:method, "get")
    route.add_requirement(:year, '\d{4,}') if path.include?(":year")
    route.add_requirement(:month, '\d{2,}') if path.include?(":month")
    route.add_requirement(:day, '\d{2,}') if path.include?(":day")
    route.save!
    
    portlet_class = "#{name.gsub(" ", "").classify}Portlet".constantize
    portlet_class.create!(
      :name => "#{name} Portlet",
      :template => portlet_class.default_template,
      :connect_to_page_id => page.id,
      :connect_to_container => "main",
      :publish_on_save => true)
  end

  def self.down
    PagePartial.destroy_all(:name => "_blog_post")
    
    destroy_blog_page("Blog Posts In Year")
    destroy_blog_page("Blog Posts In Month")
    destroy_blog_page("Blog Posts In Day")
    destroy_blog_page("Blog Post")
    
    Section.destroy_all(:name => "Blog")
    
    ContentType.destroy_all(:name => 'BlogPost')
    CategoryType.destroy_all(:name => "Blog Post")
    
    drop_table :blog_post_versions
    drop_table :blog_posts
  end
  
  def self.destroy_blog_page(name)
    Portlet.destroy_all(:name => "#{name} Portlet")
    PageRoute.destroy_all(:name => name)
    Page.destroy_all(:name => name)
  end
end
