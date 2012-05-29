require 'browsercms'

module BcmsBlog
  class Engine < Rails::Engine
    include Cms::Module
    isolate_namespace BcmsBlog
    
    config.active_record.observers = 'bcms_blog/blog_observer'
    
    config.to_prepare do
      Cms::ViewContext.send(:include, BcmsBlog::BlogHelper)
    end
  end
end