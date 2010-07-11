require File.dirname(__FILE__) + '/../test_helper'

class BlogPostControllerTest < ActionController::TestCase
  tests Cms::ContentController

  def setup
    seed_bcms_data
    seed_blog_data
    create_test_data
  end

  test "show_post" do
    get :show, :path => ['myblog', 'post'], :year => 2008, :month => 07, :day => 05, :slug => 'the-first-post'
    assert_response :success

    assert_select "title", @first_post.name
    assert_select ".blog_post", 1

    assert_select "#blog_post_#{@first_post.id}" do
      assert_select "h2 a", @first_post.name
      assert_select "div.body", @first_post.body
      assert_select "div.meta a", "General"
      assert_select "div.meta a", "0 Comments"
    end
  end

  test "non_existent_post_should_return_404" do
    get :show, :path => ["myblog"], :year => 2005, :month => 6, :day => 14, :slug => "not-here"
    assert_response :not_found
  end
end
