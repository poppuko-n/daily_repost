class DailyReport < ApplicationRecord
  belongs_to :user

  validates :date, presence: true, uniqueness: { scope: :user_id, message: "その日の日報は既に存在します" }
  validates :work_content, presence: true, length: { maximum: 2000 }
  validates :learned_points, presence: true, length: { maximum: 2000 }
  validates :improvements, presence: true, length: { maximum: 2000 }
  validates :is_public, inclusion: { in: [true, false] }
  
  validate :date_not_in_future
  scope :public_reports, -> { where(is_public: true) }
  scope :private_reports, -> { where(is_public: false) }
  scope :recent, -> { order(date: :desc) }
  scope :by_date_range, ->(start_date, end_date) { 
    return all if start_date.blank? || end_date.blank?
    where(date: start_date..end_date) 
  }
  scope :search_learned_points, ->(keyword) { 
    return none if keyword.blank?
    where("learned_points LIKE ? OR learned_points LIKE ? OR learned_points LIKE ?", 
          "%#{keyword}%", "%#{keyword.tr('ァ-ヶ', 'ｦ-ﾟ')}%", "%#{keyword.tr('ｦ-ﾟ', 'ァ-ヶ')}%")
  }
  scope :excluding, ->(report) { where.not(id: report.id) }
  scope :related_to_keywords, ->(keywords) {
    return none if keywords.empty?
    conditions = keywords.map { "learned_points LIKE ?" }
    values = keywords.map { "%#{_1}%" }
    joins(:user).where(is_public: true)
                .includes(:user)
                .where(conditions.join(' OR '), *values)
                .distinct
  }

  def related_reports(limit = 5)
    return DailyReport.none if learned_points.blank?
    
    keywords = extract_keywords
    return DailyReport.none if keywords.empty?
    
    DailyReport.related_to_keywords(keywords)
               .excluding(self)
               .limit(limit)
  end

  def status_text
    is_public? ? "公開" : "非公開"
  end
  
  private
  
  def extract_keywords
    return [] if learned_points.blank?
    
    keywords = tech_keywords_in_text + extract_words_from_text
    keywords.uniq.take(5)
  end

  def tech_keywords_in_text
    tech_keywords = [
      'TypeScript', 'React', 'Vue', 'Angular', 'JavaScript', 'Ruby', 'Rails', 'Python', 'Java',
      'データベース', 'インデックス', 'API', 'REST', 'GraphQL', 'テスト', 'TDD', 'BDD',
      'パフォーマンス', 'セキュリティ', 'デザイン', 'UI', 'UX', 'アクセシビリティ',
      'エラー', 'バグ', 'リファクタリング', '最適化', '設計', '実装', '学習'
    ]
    tech_keywords.select { |keyword| learned_points.include?(keyword) }
  end

  def extract_words_from_text
    learned_points.scan(/[ァ-ヶー]{3,}|[一-龯]{2,}/).uniq
  end

  def date_not_in_future
    return unless date.present?
    
    errors.add(:date, "未来の日付は設定できません") if date > Date.current
  end
end
