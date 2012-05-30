module BcmsBlog::RouteExtensions
  def mount_bcms_blog
    mount BcmsBlog::Engine => "/bcms_blog"
    match '/blog/feeds', :to=>"bcms_blog/feeds#index", :defaults=>{:format => "rss"}, :as=>'blog_feeds'
  end
  
  alias :routes_for_bcms_blog :mount_bcms_blog
end
