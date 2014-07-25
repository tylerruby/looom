class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]

  has_many :messages
  is_impressionable


  def likers
    Message.where(uid: self.uid)
  end

	def self.from_omniauth(auth)
	  where(auth.slice(:provider, :uid)).first_or_create do |user|
	    user.email = auth.info.email
      print "---\n Trying to set email: #{user.email} ---- \n"
	    user.password = Devise.friendly_token[0,20]
	    #user.name = auth.info.name   # assuming the user model has a name
	    #user.image = auth.info.image # assuming the user model has an image
	  end
	end

	def self.new_with_session(params, session)
    super.tap do |user|
      #access_token = response['credentials']['token']
      access_token = session["devise.facebook_data"]["credentials"]["token"]
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.get_friends(token)
      graph = Koala::Facebook::API.new(token)
      graph.get_connections("me", "friends")
  end


end
