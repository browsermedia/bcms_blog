require 'browsercms'

module BcmsBlog
  class Engine < Rails::Engine
    include Cms::Module
    
    config.active_record.observers = :blog_observer
    
  end
end