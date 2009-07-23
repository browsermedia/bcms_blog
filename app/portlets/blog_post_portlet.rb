class BlogPostPortlet < Portlet
  
  def render
    if params[:blog_post_id]
      @blog_post = BlogPost.find(params[:blog_post_id])
    elsif params[:slug]
      if params[:year]
        date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
        scope = BlogPost.published_between(date, date + 1.day)
      else
        scope = BlogPost
      end
      @blog_post = scope.with_slug(params[:slug]).first
    else
      raise BlogPost::INCORRECT_PARAMETERS
    end
    
    if @blog_post
      pmap = flash[instance_name] || params
      @blog_comment = @blog_post.comments.build pmap[:blog_comment]
      @blog_comment.errors.add_from_hash flash["#{instance_name}_errors"]
    end
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
