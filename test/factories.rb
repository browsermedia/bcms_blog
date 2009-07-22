if ActiveRecord::Base.connection.table_exists?("blogs")

Factory.define :blog do |m|
  m.sequence(:name) {|n| "TestBlog#{n}"}
end

Factory.define :blog_post do |b|
  b.sequence(:name) { |n| "BlogPost#{n}" }
  b.blog Blog.find(:first)
  b.body "Lorem ipsum"
end

end
