require File.dirname(__FILE__) + "/../test_helper"

class BlogCommentTest < ActiveSupport::TestCase
  
  test "it should not be published if Blog#moderate_comments is true" do
    assert !Factory(:blog_comment).published?
  end
  
  test "it should be published if  Blog#moderate_comments is false" do
    blog = Factory(:blog, :moderate_comments => false)
    post = Factory(:blog_post, :blog => blog)
    assert Factory(:blog_comment, :post => post).published?
  end
end