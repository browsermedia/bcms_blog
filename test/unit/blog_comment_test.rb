require 'test_helper'

class BlogCommentTest < ActiveSupport::TestCase
  
  def setup
    setup_blog_stubs
  end
  
  test "crates a valid instance" do
    assert Factory.build(:blog_comment).valid?
  end
  
  test "requires post" do
    assert Factory.build(:blog_comment, :post => nil).invalid?
  end
  
  test "requires author" do
    assert Factory.build(:blog_comment, :author => nil).invalid?
  end
  
  test "requires body" do
    assert Factory.build(:blog_comment, :body => nil).invalid?
  end
  
  test "should not be published if Blog#moderate_comments is true" do
    assert !Factory(:blog_comment).published?
  end
  
  test "should be published if  Blog#moderate_comments is false" do
    blog = Factory(:blog, :moderate_comments => false)
    post = Factory(:blog_post, :blog => blog)
    assert Factory(:blog_comment, :post => post).published?
  end
end