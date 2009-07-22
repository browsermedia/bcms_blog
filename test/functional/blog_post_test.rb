require File.dirname(__FILE__) + '/../test_helper'

class BlogPostTest < ActionController::TestCase
  tests Cms::ContentController
  
  def setup
    create_baseline_data
    @blog_post_route = PageRoute.find_by_name("Blog Post")
  end
  
  def teardown
    destroy_baseline_data
  end

  def test_show_post
    get :show_page_route, :_page_route_id => @blog_post_route.id.to_s,
      :year => @first_post.year,
      :month => @first_post.month,
      :day => @first_post.day,
      :slug => @first_post.slug
    #log @response.body
    assert_response :success
    assert_select "title", @first_post.name
    assert_select ".blog_post", 1

    assert_select "#blog_post_#{@first_post.id}" do
      assert_select "h2 a", "First Post"
      assert_select "p.body", "Yadda Yadda Yadda"
      assert_select "p.meta a", "General"
      assert_select "p.meta a", "0 Comments"
    end
    
  end
  
end
