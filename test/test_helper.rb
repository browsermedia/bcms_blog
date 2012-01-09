ENV["RAILS_ENV"] = "test"
ENV["BACKTRACE"] = 'YES PLEASE'

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'


require 'bcms_support'
require 'bcms_support/factories'
require 'blog_test_helper'

class ActiveSupport::TestCase
  include BcmsSupport::Test
  include BlogTestHelper

  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
end
