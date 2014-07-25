class UsersController < ApplicationController
  before_action :authenticate_user!

  impressionist

  def show
  	@message=Message.new
    @graph = Koala::Facebook::GraphAPI.new(session["facebook_token"])

    if params[:id].nil? # if there is no user id in params, show current one
      @user = current_user
    else 
      @user = User.find(params[:id])
    end

    @likes = @user.messages  # from this we need the uid

    users_from_likes = User.where(uid: @likes.pluck(:uid))

    @likers = @user.likers  # from this we need the user_ids

    @matches = Message.where(["user_id in (?) AND user_id in (?)",users_from_likes.pluck(:id),@likers.pluck(:user_id)])
 
    @profile_pic = @graph.get_picture("me")

    @user_info = @graph.get_object(@user.uid)
    @name = @user_info["first_name"] + " " + @user_info["last_name"]
    impressionist(@user)

  end

  def get_friends
  	@friends=User.get_friends(session["facebook_token"])

  	@filtered_friends=[]

    unless params[:q].blank?
    	@friends.each do |friend|
    		if friend["name"].downcase.include? params[:q].downcase
    			@filtered_friends << friend
    		end
    	end
    end

  end

  def index
    @message=Message.new
    @friends=User.get_friends(session["facebook_token"])

    likes = current_user.messages
    @liked_users = likes.pluck(:uid)
  end

end