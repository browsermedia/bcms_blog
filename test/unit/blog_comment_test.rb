require 'test_helper'

class BlogCommentTest < ActiveSupport::TestCase
  
  def setup
    setup_blog_stubs
  end
  
  test "crates a valid instance" do
    assert build(:blog_comment).valid?
  end
  
  test "requires post" do
    assert build(:blog_comment, :post => nil).invalid?
  end
  
  test "requires author" do
    assert build(:blog_comment, :author => nil).invalid?
  end
  
  test "requires body" do
    assert build(:blog_comment, :body => nil).invalid?
  end
  
  test "should not be published if Blog#moderate_comments is true" do
    assert !create(:blog_comment).published?
  end
  
  test "should be published if  Blog#moderate_comments is false" do
    blog = create(:blog, :moderate_comments => false)
    post = create(:blog_post, :blog => blog)
    assert create(:blog_comment, :post => post).published?
  end
end