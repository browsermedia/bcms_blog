# Blog Module for BrowserCMS

A simple blog module that lets you create one or more blogs and integrate them into your site. It features:

* Blog posts can be tagged and categorized
* The ability for users to leave comments on a blog post (stores the user name, email, url and comment)
* Support for multiple blogs
* Blog block can be added to any container in any page

## Installation
To install this module, do the following:

### A. Build and install the gem from source
This assumes you have the latest copy of the code from github on your machine.

        gem build bcms_blog.gemspec
        sudo gem install bcms_blog-1.x.x.gem

At this point, the BrowserCMS Blog gem should be installed as a gem on your system, and can be added to your projects.

### B. Adding the module to your project
In your BrowserCMS application, do the following steps.

#### 1. Edit the confing/environment.rb file

		config.gem 'browsercms'

		# Add this next line after the browsercms gem
		config.gem "bcms_blog"

#### 2. Edit the routes.rb file

		# Add this route. It must be before the core browser_cms route.
		map.routes_for_bcms_blog
		map.routes_for_browser_cms

#### 3. Install the new module code
From the root directory of your cms project, run:

		script/generate browser_cms

This will copy all the necessary views and migrations from the gems into your local project. You should messages checking to see if files already exist or were created.

#### 4. Run migrations and start the server
Modules will often add new data types, like content blocks, so you need to run the migrations to add them to your project.

		rake db:migrate
		script/server

#### 5. Create a Blog content block and embed it into your templates
* Open your browser to http://localhost:3000/cms/blogs and log in
* Click 'Add New Content', choose a name for your blog (for example, "Blog"), and click Save and Publish
* This will automatically create a new page named after the name of your blog and add your blog to it (you can delete this new page and add your Blog block to an existing page if you would rather)
* Now go to Blog Post, click 'Add New Content', and fill out the other fields to create your first post for your new blog.
* Don't forget that your new blog page won't appear in the menus until you publish the page. If you go to the Dashboard and look under Page Drafts, you will see that you can publish your new page there.
* You can navigate to your blog page using your site's main navigation menu (if you have one) or by going to the Sitemap and looking for a page with the name that you selected for your blog.

## Customization

### blog_post partial

* If you want to customize the way your blog posts are displayed, you can override the partial by copying this file from the gem to your application's directory and making changes to it: app/views/partials/_blog_post.html.haml or app/views/partials/_blog_post.html.erb (depending on if you prefer haml or erb)
* (You can run `gem which bcms_blog` to figure out where the bcms_blog files are located on your system.)
  `app/views/partials/_blog_post.html.haml` or `app/views/partials/_blog_post.html.erb` (depending on if you prefer haml or erb templates)
* Example:
        # cp /var/lib/gems/1.9.1/gems/bcms_blog-1.0.5/app/views/partials/_blog_post.html.erb app/views/partials/
* Keep in mind that the same partial is used both on the main blog page (which lists all posts) and on the blog post page (that shows a single post)
    * If you want something to only show up on the blog post page, you can enclose your markup within a `if showing_individual_post`
    * If you want something to only show up on the main blog page, you can enclose your markup within a `if !showing_individual_post`
