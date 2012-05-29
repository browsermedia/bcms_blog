# This migration comes from cms (originally 20091109175123)
class Browsercms305 < ActiveRecord::Migration
  def self.up
    add_column prefix(:users), :reset_token, :string
  end

  def self.down
    remove_column prefix(:users), :reset_token
  end
end
