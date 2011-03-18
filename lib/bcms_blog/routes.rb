module Cms::Routes
  def routes_for_bcms_blog
    match '/blog/feeds', :to=>"feeds#index", :defaults=>{:format => "rss"}, :as=>'blog_feeds'
    namespace(:cms) do     
      content_blocks :blogs
      content_blocks :blog_posts
      content_blocks :blog_comments
    end

  end
end
