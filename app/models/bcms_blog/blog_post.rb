module BcmsBlog
  class BlogPost < ActiveRecord::Base
    acts_as_content_block :taggable => true

    has_attachment :file


    before_save :set_published_at

    belongs_to :blog
    belongs_to_category
    belongs_to :author, :class_name => "Cms::User"
    has_many :comments, :class_name => "BlogComment", :foreign_key => "post_id"

    before_validation :set_slug
    validates_presence_of :name, :slug, :blog_id, :author_id

    scope :published_between, lambda { |start, finish|
      { :conditions => [
           "#{table_name}.published_at >= ? AND #{table_name}.published_at < ?",
           start, finish ] }
    }

    scope :not_tagged_with, lambda { |tag| {
      :conditions => [
        "#{table_name}.id not in (
          SELECT taggings.taggable_id FROM taggings
          JOIN tags ON tags.id = taggings.tag_id
          WHERE taggings.taggable_type = 'BlogPost'
          AND (tags.name = ?)
        )",
        tag
      ]
    } }

    INCORRECT_PARAMETERS = "Incorrect parameters. This is probably because you are trying to view the " +
                           "portlet through the CMS interface, and so we have no way of knowing what " +
                           "post(s) to show"

    delegate :editable_by?, :to => :blog

    def set_published_at
      if !published_at && publish_on_save
        self.published_at = Time.now
      end
    end

    # This is necessary because, oddly, the publish! method in the Publishing behaviour sends an update
    # query directly to the database, bypassing callbacks, so published_at does not get set by our
    # set_published_at callback.
    def after_publish_with_set_published_at
      if published_at.nil?
        self.published_at = Time.now
        self.save!
      end
      after_publish_without_set_published_at if respond_to? :after_publish_without_set_published_at
    end
    if instance_methods.map(&:to_s).include? 'after_publish'
      alias_method_chain :after_publish, :set_published_at
    else
      alias_method       :after_publish, :after_publish_with_set_published_at
    end

    def self.default_order
      "created_at desc"
    end

    def self.columns_for_index
      [ {:label => "Name", :method => :name, :order => "name" },
        {:label => "Published At", :method => :published_label, :order => "published_at" } ]
    end

    def published_label
      published_at ? published_at.to_s(:date) : nil
    end

    def set_slug
      self.slug = name.to_slug
    end

    def path
      send("#{blog.name_for_path}_post_path", route_params)
    end
    def route_name
      "#{blog.name_for_path}_post"
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
    
    # Return true if this model has an attachment
    def attachment
      !file.blank?
    end
  end
end