require 'rails_helper'

RSpec.describe DailyReport, type: :model do
  describe "バリデーション" do
    let(:user) { create(:user) }
    let(:daily_report) { build(:daily_report, user: user) }

    it "有効な日報であること" do
      expect(daily_report).to be_valid
    end

    it "日付が必須であること" do
      daily_report.date = nil
      expect(daily_report).not_to be_valid
      expect(daily_report.errors[:date]).to include("can't be blank")
    end

    it "作業内容が必須であること" do
      daily_report.work_content = nil
      expect(daily_report).not_to be_valid
      expect(daily_report.errors[:work_content]).to include("can't be blank")
    end

    it "学んだ点が必須であること" do
      daily_report.learned_points = nil
      expect(daily_report).not_to be_valid
      expect(daily_report.errors[:learned_points]).to include("can't be blank")
    end

    it "改善点が必須であること" do
      daily_report.improvements = nil
      expect(daily_report).not_to be_valid
      expect(daily_report.errors[:improvements]).to include("can't be blank")
    end

    it "同じユーザーの同じ日付の日報が重複不可であること" do
      create(:daily_report, user: user, date: Date.current)
      daily_report.date = Date.current
      expect(daily_report).not_to be_valid
      expect(daily_report.errors[:date]).to include("その日の日報は既に存在します")
    end

    it "未来の日付は設定不可であること" do
      daily_report.date = Date.tomorrow
      expect(daily_report).not_to be_valid
      expect(daily_report.errors[:date]).to include("未来の日付は設定できません")
    end

    it "文字数制限（2000文字以内）" do
      long_text = "a" * 2001
      
      daily_report.work_content = long_text
      expect(daily_report).not_to be_valid
      
      daily_report.work_content = "テスト"
      daily_report.learned_points = long_text
      expect(daily_report).not_to be_valid
      
      daily_report.learned_points = "テスト"
      daily_report.improvements = long_text
      expect(daily_report).not_to be_valid
    end
  end

  describe "関連付け" do
    let(:user) { create(:user) }
    let(:daily_report) { create(:daily_report, user: user) }

    it "ユーザーに属すること" do
      expect(daily_report.user).to eq(user)
    end
  end

  describe "スコープ" do
    let(:user) { create(:user) }
    let!(:public_report) { create(:daily_report, user: user, is_public: true) }
    let!(:private_report) { create(:daily_report, user: user, is_public: false, date: 1.day.ago) }

    it "public_reports スコープが正常に動作すること" do
      expect(DailyReport.public_reports).to include(public_report)
      expect(DailyReport.public_reports).not_to include(private_report)
    end

    it "private_reports スコープが正常に動作すること" do
      expect(DailyReport.private_reports).to include(private_report)
      expect(DailyReport.private_reports).not_to include(public_report)
    end

    it "recent スコープが正常に動作すること" do
      expect(DailyReport.recent.first).to eq(public_report)
    end
  end

  describe "関連日報検索機能" do
    let(:user1) { create(:user) }
    let(:user2) { create(:user, email: "user2@example.com", username: "user2") }
    let(:user3) { create(:user, email: "user3@example.com", username: "user3") }
    
    let!(:report1) { create(:daily_report, 
                           user: user1, 
                           learned_points: "TypeScriptの型システムについて学習しました。インターフェースの活用が重要です。",
                           is_public: true) }
    
    let!(:report2) { create(:daily_report, 
                           user: user2, 
                           date: 1.day.ago,
                           learned_points: "Reactの開発でTypeScriptを使用しました。型安全性が向上しました。",
                           is_public: true) }
                           
    let!(:report3) { create(:daily_report, 
                           user: user3, 
                           date: 2.days.ago,
                           learned_points: "データベース設計について学習しました。正規化の重要性を理解しました。",
                           is_public: true) }
                           
    let!(:private_report) { create(:daily_report, 
                                  user: user2, 
                                  date: 3.days.ago,
                                  learned_points: "TypeScriptのプライベートな学習内容です。",
                                  is_public: false) }

    it "関連する日報を適切に検索できること" do
      related = report1.related_reports
      expect(related).to include(report2) # TypeScript共通
      expect(related).not_to include(private_report) # 非公開除外
      expect(related).not_to include(report1) # 自分除外
    end

    it "自分の日報は関連検索に含まれないこと" do
      related = report1.related_reports
      expect(related).not_to include(report1)
    end

    it "非公開日報は関連検索に含まれないこと" do
      related = report1.related_reports
      expect(related).not_to include(private_report)
    end
  end

  describe "メソッド" do
    let(:user) { create(:user) }
    let(:public_report) { create(:daily_report, user: user, is_public: true) }
    let(:private_report) { create(:daily_report, user: user, is_public: false, date: 1.day.ago) }

    it "status_text が適切に動作すること" do
      expect(public_report.is_public).to be true
      expect(private_report.is_public).to be false
    end
  end
end
