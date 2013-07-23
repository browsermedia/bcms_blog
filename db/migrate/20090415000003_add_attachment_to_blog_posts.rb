class AddAttachmentToBlogPosts < ActiveRecord::Migration
  def self.up
    change_table :cms_blog_posts do |t|
      t.belongs_to :attachment
      t.integer :attachment_version
    end
    change_table :cms_blog_post_versions do |t|
      t.belongs_to :attachment
      t.integer :attachment_version
    end
  end

  def self.down
    change_table :cms_blog_posts do |t|
      t.remove :attachment
      t.remove :attachment_version
    end
    change_table :cms_blog_post_versions do |t|
      t.remove :attachment
      t.remove :attachment_version
    end
  end
end
