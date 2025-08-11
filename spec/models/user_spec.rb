require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーション" do
    let(:user) { build(:user) }

    it "有効なユーザーであること" do
      expect(user).to be_valid
    end

    it "メールアドレスが必須であること" do
      user.email = nil
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it "ユーザー名が必須であること" do
      user.username = nil
      expect(user).not_to be_valid
      expect(user.errors[:username]).to include("can't be blank")
    end

    it "ユーザー名の重複が許可されないこと" do
      create(:user, username: "testuser")
      user.username = "testuser"
      expect(user).not_to be_valid
      expect(user.errors[:username]).to include("has already been taken")
    end

    it "ユーザー名の文字数制限（2-20文字）" do
      user.username = "a"
      expect(user).not_to be_valid
      
      user.username = "a" * 21
      expect(user).not_to be_valid
      
      user.username = "ab"
      expect(user).to be_valid
      
      user.username = "a" * 20
      expect(user).to be_valid
    end

    it "表示名の文字数制限（50文字以内）" do
      user.display_name = "a" * 51
      expect(user).not_to be_valid
      
      user.display_name = "a" * 50
      expect(user).to be_valid
    end

    it "自己紹介の文字数制限（500文字以内）" do
      user.bio = "a" * 501
      expect(user).not_to be_valid
      
      user.bio = "a" * 500
      expect(user).to be_valid
    end
  end

  describe "関連付け" do
    let(:user) { create(:user) }

    it "複数の日報を持てること" do
      expect(user.daily_reports).to respond_to(:build)
    end

    it "フォロー機能が正常に動作すること" do
      other_user = create(:user, email: "other@example.com", username: "other")
      
      user.follow(other_user)
      expect(user.following?(other_user)).to be true
      expect(user.following).to include(other_user)
      expect(other_user.followers).to include(user)
      
      user.unfollow(other_user)
      expect(user.following?(other_user)).to be false
    end
  end

  describe "メソッド" do
    let(:user) { create(:user, display_name: "表示名") }
    let(:user_without_display_name) { create(:user, display_name: nil, username: "testuser") }

    it "display_name_or_username が適切に動作すること" do
      expect(user.display_name_or_username).to eq("表示名")
      expect(user_without_display_name.display_name_or_username).to eq("testuser")
    end
  end
end
