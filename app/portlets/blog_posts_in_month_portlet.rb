class BlogPostsInMonthPortlet < Portlet
  def render
    if params[:year] && params[:month]
      @date = Date.new(params[:year].to_i, params[:month].to_i)
      @blog_posts = BlogPost.published_between(@date, @date + 1.month)
    else
      raise BlogPost::INCORRECT_PARAMETERS
    end
  end
end
