class AddModerateCommentsToBlog < ActiveRecord::Migration
  def self.up
    add_content_column :cms_blogs, :moderate_comments, :boolean, :default => true
  end

  def self.down
    remove_column :cms_blogs, :moderate_comments
    remove_column :cms_blog_versions, :moderate_comments
  end
end
