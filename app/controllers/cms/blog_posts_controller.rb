class Cms::BlogPostsController < Cms::ContentBlockController
  before_filter :show_no_access_if_none_editable
  before_filter :ensure_blogs_are_editable, :only => [:create, :update]
  
  private
    
    # If the current user is not able to edit any blog, just show them a page saying so
    def show_no_access_if_none_editable
      if Blog.editable_by(current_user).empty?
        render :action => "no_access"
      end
    end
    
    # If a post is being created for a blog, then we want to make sure that the current
    # user is allowed to edit that blog
    def ensure_blogs_are_editable
      if params[:blog_post] && params[:blog_post][:blog_id] &&
         Blog.editable_by(current_user).find_by_id(params[:blog_post][:blog_id]).nil?
        raise Cms::Errors::AccessDenied
      end
    end
end
