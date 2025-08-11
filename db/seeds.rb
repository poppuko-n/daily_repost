# 初期データの作成
puts "初期データを作成中..."

# テストユーザーの作成
users = [
  {
    email: "takeshi@example.com",
    password: "password",
    username: "takeshi_dev",
    display_name: "高橋武志",
    bio: "フルスタックエンジニア。Ruby on RailsとReactを使った開発が得意です。日々の学びを記録することで成長を実感しています。"
  },
  {
    email: "yuki@example.com", 
    password: "password",
    username: "yuki_learn",
    display_name: "田中雪乃",
    bio: "バックエンドエンジニア。データベース設計とAPIの構築を専門にしています。効率的なコードの書き方を日々研究中。"
  },
  {
    email: "hiroshi@example.com",
    password: "password", 
    username: "hiroshi_code",
    display_name: "佐藤浩志",
    bio: "フロントエンドエンジニア。Vue.jsとTypeScriptでユーザーが喜ぶUIを作ることにこだわっています。"
  },
  {
    email: "mai@example.com",
    password: "password",
    username: "mai_design",
    display_name: "山田舞",
    bio: "UI/UXデザイナー兼フロントエンドエンジニア。デザインと開発の橋渡しをしながら、より良いユーザー体験を追求中。"
  },
  {
    email: "kenji@example.com",
    password: "password",
    username: "kenji_mobile",
    display_name: "鈴木健二",
    bio: "モバイルアプリエンジニア。iOSとAndroidの両方を開発。最新の技術動向をキャッチアップするのが趣味です。"
  }
]

created_users = users.map do |user_data|
  User.find_or_create_by!(email: user_data[:email]) do |user|
    user.password = user_data[:password]
    user.username = user_data[:username]
    user.display_name = user_data[:display_name]
    user.bio = user_data[:bio]
  end
end

puts "#{created_users.count}人のユーザーを作成しました"

# フォロー関係の作成
follow_relationships = [
  [0, 1], # takeshi -> yuki
  [0, 2], # takeshi -> hiroshi
  [0, 3], # takeshi -> mai
  [1, 0], # yuki -> takeshi
  [1, 2], # yuki -> hiroshi
  [1, 4], # yuki -> kenji
  [2, 0], # hiroshi -> takeshi
  [2, 3], # hiroshi -> mai
  [3, 0], # mai -> takeshi
  [3, 1], # mai -> yuki
  [3, 2], # mai -> hiroshi
  [4, 1], # kenji -> yuki
  [4, 3]  # kenji -> mai
]

follow_relationships.each do |follower_idx, followee_idx|
  follower = created_users[follower_idx]
  followee = created_users[followee_idx]
  
  Follow.find_or_create_by!(follower: follower, followee: followee)
end

puts "#{follow_relationships.count}件のフォロー関係を作成しました"

# 日報データの作成
daily_reports_data = [
  # takeshi_devの日報
  {
    user: created_users[0],
    date: 1.days.ago.to_date,
    work_content: "Ruby on Railsアプリケーションの認証機能実装を行いました。Deviseを使用してユーザー登録・ログイン・ログアウト機能を実装。また、カスタムバリデーションを追加してセキュリティを強化しました。",
    learned_points: "Deviseのカスタマイズ方法について深く学習できました。特に、strong_parametersの設定とカスタムフィールドの追加方法が理解できました。セキュリティ観点でのパスワード強度チェックの重要性も実感しました。",
    improvements: "次回は、より詳細なテストケースを先に書いてからコードを実装するTDD方式を採用したいと思います。また、セキュリティチェックリストを作成して漏れがないようにしたいです。",
    status: "public"
  },
  {
    user: created_users[0],
    date: 2.days.ago.to_date,
    work_content: "データベース設計の見直しとマイグレーションファイルの作成を行いました。正規化とインデックスの最適化に焦点を当て、パフォーマンスの向上を図りました。",
    learned_points: "データベースの正規化について理論と実践の両面から学ぶことができました。適切なインデックスの設計がクエリ性能に与える影響の大きさを実感しました。",
    improvements: "エラーハンドリングをもっと丁寧に実装すべきでした。また、マイグレーション実行前のバックアップ取得を忘れがちなので、自動化したいと思います。",
    status: "public"
  },

  # yuki_learnの日報
  {
    user: created_users[1],
    date: 1.days.ago.to_date,
    work_content: "REST APIの設計と実装を進めました。OpenAPI仕様書の作成から始まり、各エンドポイントの実装とテストケース作成まで一通り完了しました。レスポンス時間の最適化にも取り組みました。",
    learned_points: "API設計におけるRESTfulな原則の重要性を改めて理解しました。適切なHTTPステータスコードの使い分けと、一貫性のあるレスポンス形式の設計が重要だと学びました。キャッシュ戦略についても新しい知見を得ました。",
    improvements: "エラーレスポンスの設計をもう少し詳細に検討すべきでした。フロントエンド側での処理を考慮した、より使いやすいエラー情報の提供方法を考えたいと思います。",
    status: "public"
  },
  {
    user: created_users[1],
    date: 3.days.ago.to_date,
    work_content: "データベースのパフォーマンス調査と最適化を実施しました。スロークエリログの解析から始まり、インデックスの追加とクエリの書き直しを行いました。",
    learned_points: "EXPLAIN文を使った実行計画の読み方を習得できました。N+1問題の検出と解決方法、適切なインデックス設計の重要性を深く理解しました。",
    improvements: "定期的なパフォーマンス監視の仕組みを構築したいと思います。また、開発段階からパフォーマンスを意識したコードを書く習慣を身につけたいです。",
    status: "private"
  },

  # hiroshi_codeの日報  
  {
    user: created_users[2],
    date: 1.days.ago.to_date,
    work_content: "Vue.js 3のComposition APIを使ったコンポーネント設計を行いました。再利用可能なUIコンポーネントライブラリの構築と、TypeScriptでの型安全性の確保に取り組みました。",
    learned_points: "Composition APIの柔軟性とコードの再利用性の高さを実感しました。TypeScriptとの組み合わせにより、開発時のエラー検出が格段に向上することを学びました。プロップスのバリデーションの重要性も理解できました。",
    improvements: "コンポーネントのテスト coverage をもっと上げたいと思います。また、アクセシビリティへの配慮をより深く考慮したコンポーネント設計を心がけたいです。",
    status: "public"
  },
  {
    user: created_users[2], 
    date: 4.days.ago.to_date,
    work_content: "レスポンシブデザインの実装とCSS Grid、Flexboxを活用したレイアウト設計に取り組みました。モバイルファーストでのアプローチを採用しています。",
    learned_points: "CSS Gridの強力さと柔軟性を改めて実感しました。複雑なレイアウトも直感的に実現できることを学びました。モバイルファーストの設計思想がユーザー体験向上に与える影響も理解できました。",
    improvements: "ブラウザの互換性チェックをもっと早い段階で行うべきでした。また、パフォーマンス最適化の観点から、CSSの読み込み順序も見直したいと思います。",
    status: "public"
  },

  # mai_designの日報
  {
    user: created_users[3],
    date: 2.days.ago.to_date,
    work_content: "ユーザビリティテストの実施とデザインシステムの構築を進めました。統一されたデザイン言語の策定と、コンポーネントライブラリの文書化を行いました。",
    learned_points: "実際のユーザーからのフィードバックの価値を改めて認識しました。デザイナーの想定と実際のユーザー行動には大きな違いがあることを学びました。一貫性のあるデザインシステムがチーム開発に与える効果の大きさも実感できました。",
    improvements: "プロトタイプの段階でもっと多くの人からフィードバックを得るべきでした。また、アクセシビリティガイドラインの遵守をより徹底したいと思います。",
    status: "public"
  },

  # kenji_mobileの日報
  {
    user: created_users[4],
    date: 1.days.ago.to_date, 
    work_content: "React Nativeを使ったクロスプラットフォームアプリの開発を進めました。ネイティブ機能へのアクセスとパフォーマンス最適化に重点を置いて実装しました。",
    learned_points: "React Nativeの Bridge の仕組みについて深く理解できました。ネイティブモジュールの作成方法と、パフォーマンスボトルネックの特定方法を学習しました。プラットフォーム固有の最適化の重要性も実感できました。",
    improvements: "デバイス固有のテストケースをもっと充実させたいと思います。また、メモリ使用量の監視とリーク対策をより徹底して行いたいです。",
    status: "public"
  }
]

daily_reports_data.each do |report_data|
  DailyReport.find_or_create_by!(
    user: report_data[:user],
    date: report_data[:date]
  ) do |report|
    report.work_content = report_data[:work_content]
    report.learned_points = report_data[:learned_points]
    report.improvements = report_data[:improvements]
    report.is_public = (report_data[:status] == "public")
  end
end

puts "#{daily_reports_data.count}件の日報を作成しました"

puts "\n初期データの作成が完了しました！"
puts "作成されたデータ:"
puts "- ユーザー: #{User.count}人"
puts "- フォロー関係: #{Follow.count}件"
puts "- 日報: #{DailyReport.count}件"
puts "- 公開日報: #{DailyReport.where(is_public: true).count}件"
puts "- 非公開日報: #{DailyReport.where(is_public: false).count}件"
