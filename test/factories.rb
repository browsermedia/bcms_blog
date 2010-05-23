if ActiveRecord::Base.connection.table_exists?("blogs")

  Factory.define :group do |m|
    m.sequence(:name) {|n| "TestGroup#{n}" }
    m.association :group_type
  end

  Factory.define :group_type do |m|
    m.sequence(:name) {|n| "TestGroupType#{n}" }
  end

  Factory.define :user do |m|
    m.first_name "Test"
    m.last_name "User"
    m.sequence(:login) {|n| "test_#{n}" }
    m.email {|a| "#{a.login}@example.com" }
    m.password "password"
    m.password_confirmation {|a| a.password }
  end
  
  Factory.define :section do |m|
    m.name "A Section"
    m.path "/a-section"
  end

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
end
