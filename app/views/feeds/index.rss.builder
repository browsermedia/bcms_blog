xml.instruct! :xml, :version=>"1.0" 
xml.rss(:version=>"2.0") do
  xml.channel do
    xml.title("#{@blog.name} Posts Feed")
    xml.link(blog_feeds_url(:id => @blog.id, :format => "rss"))
    xml.description("")
    xml.language('en-us')
      for post in @blog_posts
        xml.item do
          xml.title(post.name)
          xml.description(post.summary) unless post.summary.blank?             
          xml.pubDate(post.published_at.strftime("%a, %d %b %Y %H:%M:%S %z")) unless post.published_at.blank?
          xml.link(send("#{@blog.name_for_path}_post_url", post.route_params))
          xml.guid(send("#{@blog.name_for_path}_post_url", post.route_params))
        end
      end
  end
end
