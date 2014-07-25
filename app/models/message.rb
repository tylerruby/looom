class Message < ActiveRecord::Base
	belongs_to :user
    validates_uniqueness_of :uid, scope: :user_id
end
