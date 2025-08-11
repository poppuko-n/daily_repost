class TimelineController < ApplicationController
  def index
    # フォロー中のユーザーの公開日報を取得
    following_ids = current_user.following.pluck(:id)
    
    @daily_reports = DailyReport.joins(:user)
                               .where(user_id: following_ids, is_public: true)
                               .includes(:user)
                               .recent
                               .page(params[:page]).per(10)
    
    # フォローしているユーザーがいない場合のメッセージ用
    @following_count = current_user.following.count
  end
end
