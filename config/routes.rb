# Only load these routes if this is the "root" application
if RAILS_ROOT == File.expand_path(File.dirname(__FILE__) + "/..")
  ActionController::Routing::Routes.draw do |map|
    map.routes_for_bcms_blog
    map.routes_for_browser_cms
  end
end
