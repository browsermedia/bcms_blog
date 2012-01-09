module Cms::BlogHelper
  # We can't call it 'blog_path' because that would conflict with the actual named route method if there's a blog named "Blog".
  def _blog_path(blog, route_name, route_params)
    send("#{blog.name_for_path}_#{route_name}_path", route_params)
  end

  def _blog_post_path(blog_post)
    send("#{blog_post.route_name}_path", blog_post.route_params)
  end
  
  def feeds_link_tag_for(name)
    blog = Blog.find_by_name(name)
    auto_discovery_link_tag(:rss, blog_feeds_url(:blog_id => blog), :title => "#{blog.name}")
  end
  
  def new_comment_path(portlet)
    url_for(:controller=>"cms/portlet", :action=>"execute_handler", :id=>portlet.id, :handler=>"create_comment")
  end
end

