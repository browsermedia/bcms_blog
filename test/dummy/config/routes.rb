Rails.application.routes.draw do

  mount BcmsBlog::Engine => "/bcms_blog"
	mount_browsercms
end
