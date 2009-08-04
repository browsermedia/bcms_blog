class Cms::BlogPostsController < Cms::ContentBlockController
  before_filter :show_no_access_if_none_editable
  
  def build_block
    super
    ensure_blog_editable
  end
  
  def load_block
    super
    ensure_blog_editable
  end
  
  def load_blocks
    super
    @blocks.delete_if { |b| !b.editable_by?(current_user) }
  end
  
  private
    
    # If the current user is not able to edit any blog, just show them a page saying so
    def show_no_access_if_none_editable
      if Blog.editable_by(current_user).empty?
        render :action => "no_access"
      end
    end
    
    # Ensure the current user can actually edit the blog this blog post is associated with
    def ensure_blog_editable
      if @block.blog
        raise Cms::Errors::AccessDenied unless @block.blog.editable_by?(current_user)
      end
    end
end
