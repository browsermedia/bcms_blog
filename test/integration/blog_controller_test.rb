require 'test_helper'

class BlogControllerTest < ActionDispatch::IntegrationTest
  def setup
    seed_bcms_data
    seed_blog_data
    create_test_data
  end

  test "displays the list of blog posts" do
    get "/myblog"

    assert_response :success
    assert_select ".blog_post", 5

    assert_select "#blog_post_#{@first_post.id}" do
      assert_select "h2 a", @first_post.name
      assert_select "div.body", @first_post.body
      assert_select "div.meta" do
        assert_select "a", 2
      end
    end
    assert_select "#blog_post_#{@foo_post_1.id}" do
      assert_select "h2 a", @foo_post_1.name
      assert_select "div.body", @foo_post_1.body
      assert_select "div.meta .tags a", "foo"
      assert_select "div.meta .tags a", "stuff"
    end
  end

  test "list of blog posts by category" do
    get "/myblog/category/General"
    assert_response :success
    assert_select ".blog_post", 3
  end

  test "list of blog posts by tag" do
    get "/myblog/tag/foo"
    assert_response :success
    assert_select ".blog_post", 2
  end

  test "list_of_blog_posts_in_day" do
    get "/myblog/2008/07/05"
    assert_response :success
    assert_select ".blog_post", 2
  end

  test "list_of_blog_posts_in_month" do
    get '/myblog/2008/07'
    assert_response :success
    assert_select ".blog_post", 3
  end

  test "list_of_blog_posts_in_year" do
    get "/myblog/2008"
    assert_response :success
    assert_select ".blog_post", 4
  end
  
  private
  
end
