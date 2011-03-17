module Cms::Routes
  def routes_for_bcms_blog
    namespace(:cms) do     
      content_blocks :blogs
      content_blocks :blog_posts
      content_blocks :blog_comments
    end
  end
end
