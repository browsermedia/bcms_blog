class Cms::BlogsController < Cms::ContentBlockController
  check_permissions :administrate, :except => :index
  
  def index
    if current_user.able_to?(:administrate)
      super
    else
      render :action => "admin_only"
    end
  end
end
