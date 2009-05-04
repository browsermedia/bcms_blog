class Cms::BlogPostPortletController < Cms::PortletController
  
  def create_comment
    blog_comment = BlogComment.new(params[:blog_comment])
    if blog_comment.save
      redirect_to_success_url
    else
      redirect_to_failure_url_with_errors(blog_comment.errors)
    end
  end
  
end