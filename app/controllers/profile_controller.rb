class ProfileController < ApplicationController
  def edit
    @user = current_user
  end

  def update
    @user = current_user
    
    if @user.update(profile_params)
      redirect_to edit_profile_path, notice: 'プロフィールが更新されました。'
    else
      render :edit
    end
  end

  private

  def profile_params
    params.require(:user).permit(:username, :display_name, :bio, :avatar_url)
  end
end
