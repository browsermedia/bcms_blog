# Blog Module for BrowserCMS

A simple blog module that lets users create multiple blogs. 

## Features

* Multiple Blogs - Contributors can create multiple blogs, each of which can have their own sections and pages.
* Convenient setup - Creating a new blog will automatically create the pages and portlets needed to get started.
* Tagging - Leverages BrowserCMS' built-in categorization and tagging and authorization framework.
* Comments - Visitors can leave comments are that can be managed, versioned and moderated. Comments can optionally be moderated.
* Flexibility - Blogs can be added to any page like any content block.
* Blog Security - When you create or edit a Blog, you can choose which groups of users can add or edit posts or comments for that blog.

## Installation

The blog module installs like most other BrowserCMS modules (http://guides.browsercms.org/installing_modules.html)

    gem install bcms_blog
    
## Set up your application to use the module

### 1. Edit config/environment.rb 
    
    config.gem "browsercms"
    config.gem "bcms_blog"
    
### 2. Run the following commands
  
    script/generate browser_cms
    rake db:migrate
  
### 3. Edit config/routes.rb

Make sure the routes.rb loads the blog routes.

    map.routes_for_bcms_blog
    map.routes_for_browser_cms

## Creating a Blog

* To get started, go to the Content Library and choose the Blog module in the left hand menu.
* Then choose the 'Blog' content type and click Add new content.
* When you create a Blog content block from the content library, all the structure needed for the blog to run is created for you. This includes a new section, 2 pages, a few page routes and a portlet.
* Go to the sitemap, and choose the first page in the newly created section (which should match the name of the blog). You will need to publish this page to make it live.
* To add new Posts, you can go to the Content Library, choose 'Blog -> Blog Post' and Add New Content. Each 'Blog Post' is tied to a particular block.
* You may also want to add Categories via the Categorization Module.

## Comments

If a Blog is configured for 'Moderate Comments', then when visitors submit them they will be automatically placed in a moderation queue for approval. In the Content Library,
under 'Blog Comments', these comments will appear in draft status. They can be Published like any other content. (There is current no automatic notification for new comments).

If the blog is set to no moderation, then comments will appear immediately. This obviously increases the likelyhood of spam, but staff can use the Content Library to delete the offending comments like any other content.

## Feeds

This module includes an RSS feeds route that can handle multiple blogs. To expose the RSS autodiscovery link, you can call the feeds\_link\_tag\_for helper in your template header:
  
    <%= feeds_link_tag_for "MyBlog" %>
    
Where "MyBlog" is the __name__ of the blog.

If your site has multiple blogs, you need to call the helper once for every link you intend to expose:

    <%= feeds_link_tag_for "MyBlog" %>
    <%= feeds_link_tag_for "MyOtherBlog" %>
 

## Security

This module adds some additional level of security around blogs and content that are slightly different from a vanilla BrowserCMS installation. Here's the highlights:

* Blogs - Only CMS Administrators may create or edit blogs themselves. Since creating a new blog has a rippling affect across the site, this keeps that from being inadvertently invoked.
* Blog Posts - Editors will only be able to see those posts in blogs they are allowed to edit. They will not be able to create posts in blogs they don't have access to.
* Comments - All Editors may edit/deleted comments. Visitors may add new comments.

## Customization

The module provides a template that is a good starting point for your blog's layout. If you want
to further customize the look and feel, just copy the file app/views/partials/\_blog_post.html.erb
on this repository to app/views/partials on your application and modify it to suit your needs.

Keep in mind that both the posts list and individual post pages are handled by the same partial.

## Routes

When each blog is created, there is an additional set of routes that are also created, based on the 'path' of the blog. The initial blog path is based on the name of the blog.

    /:blog_path/:year/:month/:day/:slug
    /:blog_path/:year/:month/:day
    /:blog_path/:year/:month
    /:blog_path/:year
    /:blog_path/tag/:tag
    /:blog_path/category/:category

## Architecture

This module will add the following new items to your project.

* New content types for Blogs, Blog Comments and Blog Posts.
* New portlets for display in a Single Blog post and for showing many blog posts.

## Contributors

Special thanks to some amazing folks from the BrowserCMS community for their work in building the essential features for this module. Here are the MVPs that made this possible:

* Tyler Rick  (http://github.com/TylerRick)
* Jon Leighton (http://github.com/jonleighton)

## Wishlist Features

* RSS feeds - Each blog should have its own RSS feed created as part of the initial blog creation.
* Notifications for Comments - Blogs should have an option to be notified when a new comment is created. This will allow for practical management of comments/spam.
* Messaging for Moderated comments - If moderation is turned on, users get no feedback about the comment they just left. Ideally, they would get some sort of javascript notice that their comment is awaiting notification.

