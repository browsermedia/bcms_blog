class BlogPost < ActiveRecord::Base
  acts_as_content_block :taggable => true
  
  before_save :set_published_at
  
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
  
  def set_published_at
    if !published_at && publish_on_save
      self.published_at = Time.now
    end
  end
  
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
    {:year => year, :month => month, :day => day, :slug => slug}
  end  
  
  def year
    published_at.strftime("%Y") unless published_at.blank?
  end
  
  def month
    published_at.strftime("%m") unless published_at.blank?
  end
  
  def day
    published_at.strftime("%d") unless published_at.blank?
  end
  
end