ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'factory_girl'
require 'mocha'
require 'test_logging'
require 'bcms_support'
require 'blog_helper'

class ActiveSupport::TestCase
  include BcmsSupport::Test
  include BlogHelper
  include TestLogging

  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
end
