class MessagesController < ApplicationController
	def create
		@fb_friends=params[:fb_friends]
		@message=params[:message] || ""

		Message.create(:uid=>@fb_friends,:message=>@message,:user_id=>current_user.id,:sent_at=>Time.now)
		flash[:success] = "You're like has been saved!"

		respond_to do |format|
			format.html { redirect_to root_path }
			format.json { render :json => { :status=> :ok, :message => "Like created!"}.to_json, :status => 200 }
		end
	end

	def destroy
		@message = current_user.messages.find_by_uid(params[:id])
		@message.destroy

		respond_to do |format|
			format.html { redirect_to root_path }
			format.json { render :json => { :status=> :ok, :message => "Deleted like!"}.to_json, :status => 200 }
		end
	end

end