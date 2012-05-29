class CreateBlogComments < ActiveRecord::Migration
  def self.up
    create_versioned_table :blog_comments do |t|
      t.integer :post_id
      t.string :author
      t.string :email
      t.string :url
      t.string :ip
      t.text :body
    end
  end

  def self.down
    drop_table :blog_comment_versions
    drop_table :blog_comments
  end
end
