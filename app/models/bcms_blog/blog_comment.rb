module BcmsBlog
  class BlogComment < ActiveRecord::Base
    acts_as_content_block :is_searachable => "body"
    belongs_to :post, :class_name => "BlogPost", :counter_cache => "comments_count"

    validates_presence_of :post_id, :author, :body
  
    before_create :publish_if_comments_are_enabled
  
    def publish_if_comments_are_enabled
      self.published = true unless post.blog.moderate_comments?
    end

    def self.default_order
      "blog_comments.created_at desc"
    end

    def self.default_order_for_search
      default_order
    end

    def self.columns_for_index
      [ {:label => "Comment",    :method => :name,                 :order => "blog_comments.body" },
        {:label => "Created At", :method => :formatted_created_at, :order => "blog_comments.created_at"} ]
    end

    def name
      body ? body[0..50] : ""
    end

    def formatted_created_at
      created_at.to_s(:date)
    end

  end
end
