module Cms::Routes
  def routes_for_bcms_blog
    
    blog_feeds '/blog/feeds', :controller => "feeds", :format => "rss"
    
    namespace(:cms) do |cms|      
      cms.content_blocks :blogs
      cms.content_blocks :blog_posts
      cms.content_blocks :blog_comments
    end
  end
end
