class DailyReportsController < ApplicationController
  before_action :set_daily_report, only: [:show, :edit, :update, :destroy]
  before_action :check_owner, only: [:edit, :update, :destroy]

  def index
    @daily_reports = current_user.daily_reports
                                 .recent
                                 .by_date_range(params[:start_date], params[:end_date])
                                 .page(params[:page]).per(20)
  end

  def show
    @related_reports = @daily_report.related_reports
  end

  def new
    redirect_to daily_reports_path
  end

  def create
    @daily_report = current_user.daily_reports.build(daily_report_params)
    
    if @daily_report.save
      redirect_to @daily_report, notice: '日報が作成されました。'
    else
      redirect_to daily_reports_path, alert: '日報の作成に失敗しました。入力内容を確認してください。'
    end
  end

  def edit
  end

  def update
    if @daily_report.update(daily_report_params)
      redirect_to @daily_report, notice: '日報が更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @daily_report.destroy
    redirect_to daily_reports_path, notice: '日報が削除されました。'
  end

  private

  def set_daily_report
    @daily_report = DailyReport.find(params[:id])
  end

  def check_owner
    redirect_to daily_reports_path, alert: 'この日報を編集する権限がありません。' unless @daily_report.user == current_user
  end

  def daily_report_params
    params.require(:daily_report).permit(:date, :work_content, :learned_points, :improvements, :is_public)
  end
end
