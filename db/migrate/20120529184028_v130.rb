require 'cms/upgrades/v3_5_0'

# Upgrade this module to v1.3.0 of BcmsBlog (Rails 3.2/CMS 3.5.x compatible)
class V130 < ActiveRecord::Migration
  def change

    rename_table "cms_blogs", "blogs"
    rename_table "cms_blog_versions", "blog_versions"
    rename_table "cms_blog_posts", "blog_posts"
    rename_table "cms_blog_post_versions", "blog_post_versions"
    rename_table "cms_blog_comments", "blog_comments"
    rename_table "cms_blog_comment_versions", "blog_comment_versions"

    ["Blog", "BlogPost", "BlogComment"].each do |model|
      v3_5_0_apply_namespace_to_block("BcmsBlog", model)
    end
    
    rename_table "blog_group_memberships", "bcms_blog_blog_group_memberships"
  end
end
