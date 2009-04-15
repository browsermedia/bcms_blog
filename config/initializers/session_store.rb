# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_browsercms_blog_module_session',
  :secret      => '42ebf92277b98591e53f666902de78de76483e2708df18e9c485af3092b9e70c54c8155d07e91cfa80c812e8e28296bcee3702b8bb11edcaea422b3b4fcff5a3'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
