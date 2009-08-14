if ActiveRecord::Base.connection.table_exists?("blogs")

Factory.define :group do |m|
  m.sequence(:name) {|n| "TestGroup#{n}" }
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

Factory.define :blog do |m|
  m.sequence(:name) {|n| "TestBlog#{n}"}
end

Factory.define :blog_post do |b|
  b.sequence(:name) { |n| "BlogPost#{n}" }
  b.blog { Factory.create(:blog) }
  b.body "Lorem ipsum"
  b.author { User.find(:first) }
end

end
