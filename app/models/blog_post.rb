class BlogPost < ActiveRecord::Base
  acts_as_content_block :taggable => true
  
  before_save :set_published_at
  
  belongs_to :blog
  belongs_to_category
  belongs_to :author, :class_name => "User"
  has_many :comments, :class_name => "BlogComment", :foreign_key => "post_id"
  
  before_validation :set_slug
  validates_presence_of :name, :slug, :blog_id
  
  named_scope :published_between, lambda { |start, finish|
    { :conditions => [
         "blog_posts.published_at >= ? AND blog_posts.published_at < ?", 
         start, finish ] }
  }
  
  INCORRECT_PARAMETERS = "Incorrect parameters. This is probably because you are trying to view the " +
                         "portlet through the CMS interface, and so we have no way of knowing what " +
                         "post(s) to show"
  
  def set_published_at
    if !published_at && publish_on_save
      self.published_at = Time.now
    end
  end
  
  # This is necessary because, oddly, the publish! method in the Publishing behaviour sends an update
  # query directly to the database, bypassing callbacks, so published_at does not get set by our
  # set_published_at callback.
  def after_publish
    if published_at.nil?
      self.published_at = Time.now
      self.save!
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
