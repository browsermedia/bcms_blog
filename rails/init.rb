gem_root = File.expand_path(File.join(File.dirname(__FILE__), ".."))
Cms.add_to_rails_paths gem_root
Cms.add_generator_paths gem_root, "db/migrate/[0-9]*_*.rb"
# Doesn't load helpers in some Rails 2 versions, use alternate code
# crh 2011-10-28
# ApplicationHelper.module_eval { include Cms::BlogHelper }
ActionView::Base.send :include, Cms::BlogHelper

config.after_initialize do
  ActiveRecord::Base.observers << BlogObserver
end
