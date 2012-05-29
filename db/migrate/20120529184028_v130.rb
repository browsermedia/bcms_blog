require 'cms/upgrades/v3_5_0'

# Upgrade this module to v1.3.0 of BcmsBlog (Rails 3.2/CMS 3.5.x compatible)
class V130 < ActiveRecord::Migration
  def change
    ["Blog", "BlogPost", "BlogComment"].each do |model|
      v3_5_0_apply_namespace_to_block("BcmsBlog", model)
    end
    
    rename_table "blog_group_memberships", "bcms_blog_blog_group_memberships"
  end
end
