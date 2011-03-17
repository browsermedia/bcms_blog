require 'browsercms'

module BcmsBlog
  class Engine < Rails::Engine
    include Cms::Module
  end
end