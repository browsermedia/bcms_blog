require File.dirname(__FILE__) + "/../test_helper"

class BlogPostTest < ActiveSupport::TestCase
  
  def setup
    setup_stubs
    @post = Factory(:blog_post, :name => "This is the first Post")
  end
  
  test "cretates a valid instance" do
    assert @post.valid?
  end
  
  test "requires name" do
    assert !Factory.build(:blog_post, :name => nil).valid?
  end
  
  test "requires blog_id" do
    assert !Factory.build(:blog_post, :blog =>  nil).valid?
  end
  
  test "requires author_id" do
    assert !Factory.build(:blog_post, :author => nil).valid?
  end
  
  test "should set slug" do
    assert_equal('this-is-the-first-post', @post.slug)
  end
  
  test "should set published_at when published" do
    assert_nil @post.published_at
    @post.publish!
    assert_not_nil @post.published_at
  end
  
  test "BlogPost should find posts published between 2 given dates" do
    @post.publish!
    Factory(:blog_post, :published_at => 5.days.ago)
    Factory(:blog_post, :published_at => 10.days.ago)
    assert_equal(1, BlogPost.published_between(6.days.ago, 4.days.ago).count)
  end
  
end
