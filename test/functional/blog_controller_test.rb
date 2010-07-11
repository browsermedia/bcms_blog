require File.dirname(__FILE__) + '/../test_helper'

class BlogControllerTest < ActionController::TestCase
  tests Cms::ContentController

  def setup
    seed_bcms_data
    seed_blog_data
    create_test_data
  end

  test "displays the list of blog posts" do
    get :show, :path => ['myblog']

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
    get :show, :path => ['myblog'], :category => 'General'
    assert_response :success
    assert_select ".blog_post", 3
  end

  # test "tagging" do
  #   get :show, :path => ['myblog'], :tag => 'foo'
  #   assert_response :success
  #   assert_equal 6, PageRoute.count
  # end
  # test "list of blog posts by tag" do
  #   get :show, :path => ['myblog'], :tag => 'foo'
  #   puts @response.body
  #   assert_response :success
  #   assert_select ".blog_post", 2
  # end
  # 
  # def test_list_of_blog_posts_in_day
  #   get :show, :path => ["myblog", "posts_in_day"],
  #   :year => 2008, :month => 7, :day => 5
  #   assert_response :success
  #   assert_select ".blog_post", 2
  # end
  # 
  # def test_list_of_blog_posts_in_month
  #   get :show, :path => ["blog", "posts_in_month"],
  #              :year => 2008, :month => 7
  #   assert_response :success
  #   assert_select ".blog_post", 3
  # end
  # 
  # def test_list_of_blog_posts_in_year
  #   get :show, :path => ["blog", "posts_in_year"],
  #       :year => 2008
  #   assert_response :success
  #   assert_select ".blog_post", 4
  # end
end
