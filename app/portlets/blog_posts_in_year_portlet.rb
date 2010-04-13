class BlogPostsInYearPortlet < Portlet
  def render
    if params[:year]
      @date = Date.new(params[:year].to_i)
      @blog_posts = Blog.find(self.blog_id).posts.published_between(@date, @date + 1.year)
      raise ActiveRecord::RecordNotFound.new("No posts found") if @blog_posts.empty?
    else
      raise BlogPost::INCORRECT_PARAMETERS
    end
  end
end
