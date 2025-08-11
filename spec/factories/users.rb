FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:username) { |n| "user#{n}" }
    password { "password123" }
    password_confirmation { "password123" }
    display_name { "テストユーザー" }
    bio { "テスト用の自己紹介文です。" }
    avatar_url { nil }

    trait :with_display_name do
      display_name { "表示名付きユーザー" }
    end

    trait :without_display_name do
      display_name { nil }
    end

    trait :with_bio do
      bio { "詳細な自己紹介文です。プログラミングが趣味で、日々学習を続けています。" }
    end

    trait :with_avatar do
      avatar_url { "https://example.com/avatar.jpg" }
    end
  end
end
