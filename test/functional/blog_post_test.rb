require 'test_helper'

class BlogPostTest < ActionController::TestCase
  tests Cms::ContentController
  
  def setup
    setup_stubs
    create_baseline_data
  end
  
  # def teardown
  #   destroy_baseline_data
  # end
  
  def test_show_post
    get :show, :path => ["blog", "post"],
      :year => @first_post.year,
      :month => @first_post.month,
      :day => @first_post.day,
      :slug => @first_post.slug
    #log @response.body
    assert_response :success
    assert_select "title", @first_post.name
    assert_select ".blog_post", 1
  
    assert_select "#blog_post_#{@first_post.id}" do
      assert_select "h2 a", @first_post.name
      assert_select "p.body", @first_post.body
      assert_select "p.meta a", "General"
      assert_select "p.meta a", "0 Comments"
    end
    
  end
  
  # def test_non_existent_slug_should_return_404
  #   get :show, :path => ["blog", "post"],
  #     :year => 2005, :month => 6, :day => 14,
  #     :slug => "not-here"
  #   assert_response :not_found
  # end
  
end
