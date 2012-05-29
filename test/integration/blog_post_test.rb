require 'test_helper'

class BlogPostIntegrationTest < ActionController::IntegrationTest
  
  def setup
    seed_bcms_data
    seed_blog_data
    create_test_data
  end
  
  def test_show_post
    get "/myblog/#{@first_post.year}/#{@first_post.month}/#{@first_post.day}/#{@first_post.slug}"
    assert_response :success
    assert_select "title", @first_post.name
    assert_select ".blog_post", 1
  
    assert_select "#blog_post_#{@first_post.id}" do
      assert_select "h2 a", @first_post.name
      assert_select ".body", @first_post.body
      assert_select ".meta a", "General"
      assert_select ".meta a", "0 Comments"
    end
    
  end
  
  test "non_existent_post_should_return_404" do
    get "/myblog/2005/6/14/non-existent"
    assert_response :not_found
  end
  
end
