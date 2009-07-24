class CreateBlogs < ActiveRecord::Migration
  def self.up
    create_versioned_table :blogs do |t|
      t.string :name
      t.string :format
      t.text :template
    end
    ContentType.create!(:name => "Blog", :group_name => "Blog")
    
    blog_page = Page.first(:conditions => {:path => "/"})
      
    Blog.create!(
      :name => "My Blog",
      :template => Blog.default_template,
      :connect_to_page_id => blog_page.id,
      :connect_to_container => "main",
      :publish_on_save => true)
      
    blog_page.page_routes.create(
      :name => "Blog Posts With Tag",
      :pattern => "/articles/tag/:tag")
      
    blog_page.page_routes.create(
      :name => "Blog Posts In Category", 
      :pattern => "/articles/category/:category")
  end

  def self.down
    PageRoute.delete_all(:pattern => ["/articles/tag/:tag", "/articles/category/:category"])
    ContentType.delete_all(:name => "Blog")
    drop_table :blogs
  end
end
