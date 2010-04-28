# Ideally, we would create a new migration whenever we wanted to make changes to an existing
# migration that is already in circulation, instead of simply editing the existing migrations
# and publishing the new version, because doing rake db:migrate:redo VERSION=20090415000000,
# etc. on each updated migration is not only a pain but will probably result in more data being
# lost than is strictly necessary -- assuming the migrations work correctly at all.
#
# On the other hand, there's something pretty compelling about "fixing" the migration so that
# it doesn't have any useless steps that are just going to get reverted by the next migration.
#
# There is also the problem of model dependencies: you can't safely remove a model in the same
# commit that you use that model in a migration (f.e., Model.destroy_all). Even if you remove it
# in the following commit, it's only safe if people check out every intermediate version and run
# db:migrate at each version, instead of simply checking out the tip version and then running
# db:migrate. And people don't do that.
#
# Anyway, I guess we assume that there are only a few brave souls out there who are already
# using bcms_blog and hope for the best. Here is the "missing migration"; hopefully it will be
# helpful to you.
#
# Run this script instead of re-running the changed migrations with rake db:migrate:redo so that
# your blog data is not destroyed.
#
# Usage: ./script/runner 'require "/path/to/bcms_blog/doc/migrate_to_20100427.rb"'

require 'pp'

Page # trigger auto-loading
# At the time of this writing, these associations are missing :dependent => :destroy
class Page
  has_many :page_routes, :dependent => :destroy
end
class PageRoute
  has_many :requirements, :class_name => "PageRouteRequirement", :dependent => :destroy
  has_many :conditions,   :class_name => "PageRouteCondition",   :dependent => :destroy
end

# Added these here because these classes will be removed by the next commit, so if anyone tried to run this script in future versions it would have a missing constant error unless we keep these class definitions around
class BlogPostsInCategoryPortlet < Portlet; end
class BlogPostsWithTagPortlet    < Portlet; end
class BlogPostPortlet            < Portlet; end
class BlogPostsInDayPortlet      < Portlet; end
class BlogPostsInMonthPortlet    < Portlet; end
class BlogPostsInYearPortlet     < Portlet; end

class MigrateTo20100427 < ActiveRecord::Migration
  def self.up
    drop_table :blog_group_membership_versions

    PageRouteOption.all.each {|a| a.destroy unless a.page_route }

    puts "Destroying portlets, pages, page_routes left over from old version of bcms_blog..."
    puts "(*Not* destroying any existing Blogs, pages on which Blogs are connected, or BlogPosts)"
    portlets = [BlogPostPortlet, BlogPostsInCategoryPortlet, BlogPostsWithTagPortlet, BlogPostsInDayPortlet, BlogPostsInMonthPortlet, BlogPostsInYearPortlet]
    #pp portlets.map(&:all).flatten.map(&:connected_pages).flatten.map(&:page_routes).flatten.each(&:destroy)
    pp portlets.map(&:all).flatten.map(&:connected_pages).flatten.each(&:destroy)
    pp portlets.map(&:all).flatten.each(&:destroy)

    # Something like this might not work if they have moved their Blog page to a different section or to no section, so we better let users resolve this manually...
    #Blog.all.map(&:connected_pages).flatten.each do |page|
    #  page.hidden = true
    #  page.save!
    #  page.section.hidden = false
    #  page.section.save!
    #end

    puts "Calling after_create on each Blog in the system..."
    Blog.all.each do |blog|
      puts "#{blog}..."
      blog.send :after_create
    end
  end

  def self.down
  end
end

MigrateTo20100427.up
