class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # 関連付け
  has_many :daily_reports, dependent: :destroy
  
  # フォロー機能の関連付け
  has_many :active_follows, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_follows, class_name: "Follow", foreign_key: "followee_id", dependent: :destroy
  has_many :following, through: :active_follows, source: :followee
  has_many :followers, through: :passive_follows, source: :follower

  # バリデーション
  validates :username, presence: true, uniqueness: { case_sensitive: false }, 
                       length: { minimum: 2, maximum: 20 },
                       format: { with: /\A[a-zA-Z0-9_]+\z/, message: "英数字とアンダースコアのみ使用可能です" }
  validates :display_name, length: { maximum: 50 }
  validates :bio, length: { maximum: 500 }
  validates :avatar_url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: "正しいURL形式で入力してください" }, allow_blank: true

  # メソッド
  def follow(other_user)
    return false if self == other_user
    following << other_user unless following?(other_user)
  end

  def unfollow(other_user)
    following.delete(other_user)
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def display_name_or_username
    display_name.present? ? display_name : username
  end
end
