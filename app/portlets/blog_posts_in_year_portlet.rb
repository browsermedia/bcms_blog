class BlogPostsInYearPortlet < Portlet
  def render
    if params[:year]
      @date = Date.new(params[:year].to_i)
      @blog_posts = BlogPost.published_between(@date, @date + 1.year)
    else
      raise BlogPost::INCORRECT_PARAMETERS
    end
  end
end
