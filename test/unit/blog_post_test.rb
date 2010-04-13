require File.dirname(__FILE__) + "/../test_helper"

class BlogPostTest < ActiveSupport::TestCase
  
  def test_existing_record_should_record_published_at_when_published
    @blog_post = Factory.create(:blog_post)
    
    assert_nil @blog_post.published_at
    assert !@blog_post.new_record?
    
    @blog_post.publish!
    
    assert_not_nil @blog_post.published_at
  end
  
end
