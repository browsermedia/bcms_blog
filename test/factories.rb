Factory.define :blog do |m|
  m.sequence(:name) {|n| "TestBlog#{n}"}
  m.moderate_comments true
end

Factory.define :blog_post do |m|
  m.sequence(:name) { |n| "BlogPost#{n}" }
  m.blog {|b| b.association(:blog) }
  m.sequence(:body) { |n| "Lorem ipsum #{n}" }
  m.association :author, :factory => :user
end

Factory.define :blog_comment do |m|
  m.name "Just a comment"
  m.body "Nice blog"
  m.association :post, :factory => :blog_post
  m.association :author, :factory => :user
end
