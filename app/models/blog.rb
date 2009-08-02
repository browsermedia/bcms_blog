class Blog < ActiveRecord::Base
  acts_as_content_block
  has_many :posts, :class_name => "BlogPost"
  
  has_many :blog_group_memberships
  has_many :groups, :through => :blog_group_memberships
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  def self.default_template
    template_file = ActionController::Base.view_paths.map do |vp| 
      path = vp.to_s.first == "/" ? vp.to_s : File.join(Rails.root, vp.to_s)
      File.join(path, "cms/blogs/render.html.erb")
    end.detect{|f| File.exists? f }
    template_file ? open(template_file){|f| f.read } : ""
  end
  
  def render
    @blog = self
    finder = @blog.posts.published
    if params[:tag]
      finder = finder.tagged_with(params[:tag])
    end
    if params[:category]
      @category_type = CategoryType.named("Blog Post").first
      @category = @category_type.categories.named(params[:category]).first
      finder = finder.in_category(@category)
    end
    @blog_posts = finder.all(:limit => 15, :order => "published_at desc") 
  end
  
  def inline_options
    {:inline => self.template}
  end
  
  def self.default_order
    "name"
  end
  
end
