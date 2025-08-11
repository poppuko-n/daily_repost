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
  scope :search_learned_points, ->(keyword) { 
    return none if keyword.blank?
    # 日本語対応のため、LIKE検索と部分文字列マッチングを使用
    where("learned_points LIKE ? OR learned_points LIKE ? OR learned_points LIKE ?", 
          "%#{keyword}%", "%#{keyword.tr('ァ-ヶ', 'ｦ-ﾟ')}%", "%#{keyword.tr('ｦ-ﾟ', 'ァ-ヶ')}%")
  }

  # メソッド
  def related_reports(limit = 5)
    return DailyReport.none if learned_points.blank?
    
    # 重要なキーワードを抽出
    keywords = extract_keywords(learned_points)
    return DailyReport.none if keywords.empty?
    
    # 各キーワードでマッチする日報を検索（自分以外）
    related = DailyReport.joins(:user)
                         .where.not(id: id)
                         .where(is_public: true)
                         .includes(:user)
    
    # OR条件で複数キーワードを検索
    conditions = keywords.map { |keyword| "learned_points LIKE ?" }
    values = keywords.map { |keyword| "%#{keyword}%" }
    
    related.where(conditions.join(' OR '), *values)
           .distinct
           .limit(limit)
  end
  
  private
  
  def extract_keywords(text)
    # 技術用語や重要なキーワードを抽出
    keywords = []
    
    # 一般的な技術キーワードをマッチ
    tech_keywords = [
      'TypeScript', 'React', 'Vue', 'Angular', 'JavaScript', 'Ruby', 'Rails', 'Python', 'Java',
      'データベース', 'インデックス', 'API', 'REST', 'GraphQL', 'テスト', 'TDD', 'BDD',
      'パフォーマンス', 'セキュリティ', 'デザイン', 'UI', 'UX', 'アクセシビリティ',
      'エラー', 'バグ', 'リファクタリング', '最適化', '設計', '実装', '学習'
    ]
    
    tech_keywords.each do |keyword|
      keywords << keyword if text.include?(keyword)
    end
    
    # 3文字以上の名詞的な単語を抽出（カタカナ・漢字）
    words = text.scan(/[ァ-ヶー]{3,}|[一-龯]{2,}/)
    keywords.concat(words.uniq)
    
    keywords.uniq.take(5) # 最大5個のキーワード
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
