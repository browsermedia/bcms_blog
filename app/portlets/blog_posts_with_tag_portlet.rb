class BlogPostsWithTagPortlet < Portlet
  def render
    if params[:tag]
      finder = Blog.find(self.blog_id).posts.published.tagged_with(params[:tag])
      @blog_posts = finder.all(:limit => 15, :order => "published_at desc")
      raise ActiveRecord::RecordNotFound.new("No posts found") if @blog_posts.empty?
    else
      raise BlogPost::INCORRECT_PARAMETERS
    end
  end
end
