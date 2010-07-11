ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'mocha'
require 'factory_girl'
require 'bcms_support'
require 'bcms_support/factories'
require 'blog_helper'
require 'test_logging'

class ActiveSupport::TestCase
  include BcmsSupport::Test
  include BlogHelper
  include TestLogging

  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
end
