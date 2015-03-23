class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
  		flash[:success] = "Welcome to the Sample App!"
  		redirect_to @user
      log_in @user
  	else
  		render 'new'
		end
	end

	def index
		@users = User.all
	end
	private

	# takes params[:user] and makes sure that only allowed hashes pass through
	# create and update functions use it to make sure they only take allowed hashes
		def user_params
			params.require(:user).permit(:name, :email, :password, :password_confirmation)
		end
end
