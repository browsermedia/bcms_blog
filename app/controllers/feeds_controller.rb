class FeedsController < ApplicationController
  
  def index
    @blog = Blog.find(params[:blog_id])
    @blog_posts = @blog.posts.published.all(:limit => 10, :order => "published_at DESC")
  end
  
end
