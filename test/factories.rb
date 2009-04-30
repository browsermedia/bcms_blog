Factory.define :blog do |m|
  m.sequence(:name) {|n| "TestBlog#{n}"}
end