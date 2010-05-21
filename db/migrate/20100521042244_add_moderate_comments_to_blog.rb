class AddModerateCommentsToBlog < ActiveRecord::Migration
  def self.up
    add_column :blogs, :moderate_comments, :boolean, :default => true
  end

  def self.down
    remove_column :blogs, :moderate_comments
  end
end
