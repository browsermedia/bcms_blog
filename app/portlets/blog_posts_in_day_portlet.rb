class BlogPostsInDayPortlet < Portlet
  def render
    if params[:year] && params[:month] && params[:day]
      @date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
      @blog_posts = BlogPost.published_between(@date, @date + 1.day)
    else
      raise BlogPost::INCORRECT_PARAMETERS
    end
  end
end
