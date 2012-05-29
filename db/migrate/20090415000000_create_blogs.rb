require 'pp'

Cms::Page # trigger auto-loading
# At the time of this writing, these associations are missing :dependent => :destroy
class Cms::Page
  has_many :page_routes, :dependent => :destroy
end
class Cms::PageRoute
  has_many :requirements, :class_name => "PageRouteRequirement", :dependent => :destroy
  has_many :conditions,   :class_name => "PageRouteCondition",   :dependent => :destroy
end

class CreateBlogs < ActiveRecord::Migration
  def self.up
    create_versioned_table :blogs do |t|
      t.string :name
      t.string :format
      t.text :template
    end
    
    create_table :blog_group_memberships do |t|
      t.integer :blog_id
      t.integer :group_id
    end
    
  end

  def self.down
    puts "Destroying portlets, pages, page_routes..."
    pp (portlets = BlogPostPortlet.all).map(&:connected_pages).flatten.each(&:destroy)
    pp portlets.each(&:destroy)

    #Blog.all.map(&:connected_pages).flatten.map(&:page_routes).flatten.each(&:destroy)
    pp Blog.all.map(&:connected_pages).flatten.each(&:destroy)

    Cms::ContentType.destroy_all(:name => "Blog")
    Cms::Connector.destroy_all(:connectable_type => "Blog")

    drop_table :blog_versions
    drop_table :blogs

    drop_table :blog_group_memberships
  end
end
