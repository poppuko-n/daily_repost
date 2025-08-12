class FollowsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def create
    if current_user.follow(@user)
      redirect_back(fallback_location: users_path)
    else
      redirect_back(fallback_location: users_path, alert: 'フォローできませんでした。')
    end
  end

  def destroy
    if current_user.unfollow(@user)
      redirect_back(fallback_location: users_path)
    else
      redirect_back(fallback_location: users_path, alert: 'フォローを解除できませんでした。')
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end