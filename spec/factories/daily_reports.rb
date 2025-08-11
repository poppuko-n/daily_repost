FactoryBot.define do
  factory :daily_report do
    association :user
    date { Date.current }
    work_content { "今日はRuby on Railsのアプリケーション開発を行いました。認証機能の実装とテストの作成を完了しました。" }
    learned_points { "Deviseの設定方法とRSpecのテスト書き方について学びました。適切なバリデーションの重要性を理解できました。" }
    improvements { "次回はより詳細なテストケースを作成したいと思います。エラーハンドリングも改善できそうです。" }
    is_public { true }

    trait :private_report do
      is_public { false }
    end

    trait :public_report do
      is_public { true }
    end

    trait :yesterday do
      date { 1.day.ago }
    end

    trait :with_typescript_content do
      learned_points { "TypeScriptの型システムについて深く学習しました。インターフェースとジェネリクスの活用方法を習得できました。" }
    end

    trait :with_database_content do
      learned_points { "データベース設計とインデックス最適化について学習しました。パフォーマンスチューニングの重要性を理解できました。" }
    end
  end
end
