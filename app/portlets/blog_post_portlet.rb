class BlogPostPortlet < Portlet
  
  def render
    scope = Blog.find(self.blog_id).posts
    if params[:blog_post_id]
      @blog_post = scope.find(params[:blog_post_id])
    elsif params[:slug]
      if params[:year]
        date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
        scope = scope.published_between(date, date + 1.day)
      end
      @blog_post = scope.find_by_slug!(params[:slug])
    else
      raise BlogPost::INCORRECT_PARAMETERS
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
