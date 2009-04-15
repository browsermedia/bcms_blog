class BlogPost < ActiveRecord::Base
  acts_as_content_block :taggable => true
  belongs_to :blog
  belongs_to_category
  belongs_to :author, :class_name => "User"
  has_many :comments, :class_name => "BlogComment", :foreign_key => "post_id"
  
  before_validation :set_slug
  validates_presence_of :name, :slug

  named_scope :published_on, lambda {|date|
    d = if date.kind_of?(Hash)
      Date.new(date[:year].to_i, date[:month].to_i, date[:day].to_i)
    else
      date
    end
    
    {:conditions => [
      "blog_posts.published_at >= ? AND blog_posts.published_at < ?", 
      d.beginning_of_day, 
      (d.beginning_of_day + 1.day)
    ]}
  }
      
  named_scope :with_slug, lambda{|slug| {:conditions => ["blog_posts.slug = ?",slug]}}  
  
  def self.default_order
    "created_at desc"
  end
  
  def self.columns_for_index
    [ {:label => "Name", :method => :name, :order => "name" },
      {:label => "Published", :method => :published_label, :order => "published" } ]
  end  
  
  def published_label
    published_at ? published_at.to_s(:date) : nil
  end
  
  def set_slug
    self.slug = name.to_slug
  end
  
  def route_params
    {:year => published_at.strftime("%Y"), 
      :month => published_at.strftime("%m"), 
      :day => published_at.strftime("%d"), 
      :slug => slug}
  end  
  
end