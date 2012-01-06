class BlogPostsPortlet < Portlet
  
  after_initialize :build_permalink_code
  
  def build_permalink_code
    self.render_blog_post_code ||= 'truncate(blog_post.name, 30)'
  end

  # Mark this as 'true' to allow the portlet's template to be editable via the CMS admin UI.
  enable_template_editor false

  def render(_options = {})
    # Since we can't pass any options to render_portlet, you can use $blog_posts_portlet_options if you want to pass in/override some options
    # This is an ugly workaround for https://browsermedia.lighthouseapp.com/projects/28481-browsercms-30/tickets/350-make-it-possible-to-pass-options-to-render_portletrender_connectable in case we want to call render_portlet with some options
    _options = $blog_posts_portlet_options || {}
    _options.symbolize_keys!

    portlet_attributes = self.portlet_attributes.inject({}) {|hash, a| hash[a.name] = a.value; hash}.reject {|k,v| v.blank?}.symbolize_keys

    #options.reverse_merge!(params.slice(:tags)).symbolize_keys!
    @options = portlet_attributes.merge(_options)
    Rails.logger.debug "... BlogPostsPortlet#render(options=#{@options.inspect} #{@options.class})"

    if @options[:blog_id]
      finder = Blog.find(@options[:blog_id]).posts
    elsif @options[:blog_name]
      finder = Blog.find_by_name(@options[:blog_name]).posts
    else
      finder = BlogPost
    end

    if @options[:tags].is_a?(Array) && @options[:tags].size > 1
      other_tags = @options[:tags][1..-1]
      @options[:tags] = @options[:tags][0]
    end

    finder = finder.published
    finder = Blog.posts_finder(finder, @options)

    @blog_posts = finder.all(
      :limit => @options[:limit] || 25,
      :order => "published_at desc"
    )

    if other_tags
      @blog_posts.select! {|p| (p.tags.map(&:name).map(&:downcase) & other_tags.map(&:downcase)).size == other_tags.size }
    end

    raise ActiveRecord::RecordNotFound.new("No articles found") if @blog_posts.empty?

    @portlet = self
  end
end
