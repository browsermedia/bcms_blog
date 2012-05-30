require 'browsercms'

module BcmsBlog
  class Engine < Rails::Engine
    include Cms::Module
    isolate_namespace BcmsBlog
    
    config.active_record.observers = 'bcms_blog/blog_observer'
    
    config.to_prepare do
      Cms::ViewContext.send(:include, BcmsBlog::BlogHelper)
      ApplicationHelper.send(:include, BcmsBlog::BlogHelper)
    end
    
    initializer 'bcms_blog.route_extensions', :after => 'action_dispatch.prepare_dispatcher' do |app|
       ActionDispatch::Routing::Mapper.send :include, BcmsBlog::RouteExtensions
    end
    
    config.before_configuration do |app|
      # Used by blog_feed_url to determine the host
      Rails.application.routes.default_url_options[:host]= config.cms.site_domain
    end
  end
end