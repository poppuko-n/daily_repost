FactoryBot.define do
  factory :daily_report do
    user { nil }
    date { "2025-08-11" }
    work_content { "MyText" }
    learned_points { "MyText" }
    improvements { "MyText" }
    is_public { false }
  end
end
