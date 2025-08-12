class UsersController < ApplicationController
  before_action :set_user, only: [:show, :followers, :following]

  def index
    @users = User.excluding_user(current_user)
                 .search_by_term(params[:search])
                 .order(:username)
                 .page(params[:page]).per(20)
  end

  def show
    @daily_reports = @user.daily_reports.public_reports.recent
                          .page(params[:page]).per(10)
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
