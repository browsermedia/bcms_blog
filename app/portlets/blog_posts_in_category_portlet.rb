class BlogPostsInCategoryPortlet < Portlet
  def render
    if params[:category]
      @category_type = CategoryType.named("Blog Post").first
      @category = @category_type.categories.named(params[:category]).first
      finder = Blog.find(self.blog_id).posts.published.in_category(@category)
      @blog_posts = finder.all(:limit => 15, :order => "published_at desc")
      raise ActiveRecord::RecordNotFound.new("No posts found") if @blog_posts.empty?
    else
      raise BlogPost::INCORRECT_PARAMETERS
    end
  end
end
