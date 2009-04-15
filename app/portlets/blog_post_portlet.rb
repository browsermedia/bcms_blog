class BlogPostPortlet < Portlet
  
  def render
    # @blog_post should already be set by the page route
    if !@blog_post && params[:blog_post_id]
      @blog_post = BlogPost.find(params[:blog_post_id])
    end
  end
    
end