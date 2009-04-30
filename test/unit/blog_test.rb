require File.dirname(__FILE__) + '/../test_helper'

class BlogTest < ActiveSupport::TestCase
  def test_create
    Factory(:blog)
  end
end