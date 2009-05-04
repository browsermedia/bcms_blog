module Cms::Routes
  def routes_for_browser_cms_blog_module
    namespace(:cms) do |cms|      
      cms.content_blocks :blogs
      cms.content_blocks :blog_posts
      cms.content_blocks :blog_comments
      cms.create_blog_comment "/blog_post_portlet/:id/create_comment", 
        :controller => "blog_post_portlet", 
        :action => "create_comment", 
        :conditions => {:method => :post}        
    end
  end
end
