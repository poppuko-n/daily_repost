class UsersController < ApplicationController
  before_action :set_user, only: [:show, :follow, :unfollow, :followers, :following]

  def index
    @users = User.where.not(id: current_user.id)
                .order(:username)
                .page(params[:page]).per(20)
    
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @users = @users.where("username LIKE ? OR display_name LIKE ?", search_term, search_term)
    end
  end

  def show
    @daily_reports = @user.daily_reports.public_reports.recent
                          .page(params[:page]).per(10)
  end

  def follow
    if current_user.follow(@user)
      redirect_back(fallback_location: @user, notice: "#{@user.display_name_or_username}さんをフォローしました。")
    else
      redirect_back(fallback_location: @user, alert: "フォローできませんでした。")
    end
  end

  def unfollow
    current_user.unfollow(@user)
    redirect_back(fallback_location: @user, notice: "#{@user.display_name_or_username}さんのフォローを解除しました。")
  end

  def followers
    @followers = @user.followers.order(:username).page(params[:page]).per(20)
  end

  def following
    @following = @user.following.order(:username).page(params[:page]).per(20)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
