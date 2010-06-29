require File.dirname(__FILE__) + '/../test_helper'

class BlogPostTest < ActionController::TestCase
  tests Cms::ContentController
  
  def setup
    create_baseline_data
  end

=begin  
  def test_show_post
    get :show, :path => ["myblog"],
               :year => 2008,
               :month => 07,
               :day => 05
    log @response.body
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
=end
  
  def test_non_existent_slug_should_return_404
    get :show, :path => ["blog", "post"],
      :year => 2005, :month => 6, :day => 14,
      :slug => "not-here"
    assert_response :not_found
  end
  
end
