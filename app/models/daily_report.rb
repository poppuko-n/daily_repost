class DailyReport < ApplicationRecord
  belongs_to :user

  # バリデーション
  validates :date, presence: true, uniqueness: { scope: :user_id, message: "その日の日報は既に存在します" }
  validates :work_content, presence: true, length: { maximum: 2000 }
  validates :learned_points, presence: true, length: { maximum: 2000 }
  validates :improvements, presence: true, length: { maximum: 2000 }
  validates :is_public, inclusion: { in: [true, false] }
  
  # 日付が未来でないことをチェック
  validate :date_not_in_future

  # スコープ
  scope :public_reports, -> { where(is_public: true) }
  scope :private_reports, -> { where(is_public: false) }
  scope :recent, -> { order(date: :desc) }
  scope :by_date_range, ->(start_date, end_date) { where(date: start_date..end_date) }
  scope :search_learned_points, ->(keyword) { where("MATCH(learned_points) AGAINST(? IN NATURAL LANGUAGE MODE)", keyword) }

  # メソッド
  def related_reports(limit = 5)
    return DailyReport.none if learned_points.blank?
    
    # キーワードベースで関連する日報を検索（自分以外）
    DailyReport.joins(:user)
               .where.not(id: id)
               .where(is_public: true)
               .search_learned_points(learned_points)
               .includes(:user)
               .limit(limit)
  end

  def status_text
    is_public? ? "公開" : "非公開"
  end

  private

  def date_not_in_future
    return unless date.present?
    
    errors.add(:date, "未来の日付は設定できません") if date > Date.current
  end
end
