class BlogPostPortlet < Portlet
  
  def render
    # @blog_post should already be set by the page route
    if !@blog_post && params[:blog_post_id]
      @blog_post = BlogPost.find(params[:blog_post_id])
    end
    pmap = flash[instance_name] || params
    @blog_comment = @blog_post.comments.build pmap[:blog_comment]
    @blog_comment.errors.add_from_hash flash["#{instance_name}_errors"]
  end
  
  def create_comment
    blog_comment = BlogComment.new(params[:blog_comment])
    if blog_comment.save
      url_for_success
    else
      store_params_in_flash
      store_errors_in_flash(blog_comment.errors)
      url_for_failure
    end
  end  
    
end