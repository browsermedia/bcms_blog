class CreateBlogPosts < ActiveRecord::Migration
  def self.up
    create_versioned_table :blog_posts do |t|
      t.integer :blog_id
      t.integer :author_id
      t.integer :category_id
      t.string :name
      t.string :slug
      t.text :summary
      t.text :body, :size => (64.kilobytes + 1)
      t.integer :comments_count
      t.datetime :published_at
    end

  end

  def self.down
    drop_table :blog_post_versions
    drop_table :blog_posts
  end
end
