class BlogGroupMembership < ActiveRecord::Base
  belongs_to :blog
  belongs_to :group
end
