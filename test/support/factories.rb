require 'factory_girl'
# These factories are copied from bcms_support to avoid needing to update dependency

FactoryGirl.define do
  factory :user, :class => Cms::User do |m|
    m.first_name "Test"
    m.last_name "User"
    m.sequence(:login) {|n| "test_#{n}" }
    m.email {|a| "#{a.login}@example.com" }
    m.password "password"
    m.password_confirmation {|a| a.password }
  end
  
  factory :group_type, :class => Cms::GroupType do |m|
    m.sequence(:name) {|n| "TestGroupType#{n}" }
  end

  factory :group, :class => Cms::Group do |m|
    m.sequence(:name) {|n| "TestGroup#{n}" }
  end
  
  factory :permission, :class => Cms::Permission do |m|
    m.sequence(:name) {|n| "TestPermission#{n}" }
  end
end


# Blog specific factories
FactoryGirl.define do
  factory :blog, :class=>BcmsBlog::Blog do |m|
    m.sequence(:name) {|n| "TestBlog#{n}"}
    m.moderate_comments true
  end

  factory :blog_post, :class=>BcmsBlog::BlogPost do |m|
    m.sequence(:name) { |n| "BlogPost#{n}" }
    m.blog {|b| b.association(:blog) }
    m.sequence(:body) { |n| "Lorem ipsum #{n}" }
    m.association :author, :factory => :user
  end

  factory :blog_comment, :class=>BcmsBlog::BlogComment do |m|
    m.name "Just a comment"
    m.body "Nice blog"
    m.association :post, :factory => :blog_post
    m.association :author, :factory => :user
  end

  factory :root_section, :class=>Cms::Section do |m|
    m.name "My Site"
    m.root true
    m.path "/"
  end
end
