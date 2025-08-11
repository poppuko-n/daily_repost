# 日報管理アプリケーション要件定義

## 1. プロジェクト概要
マルチユーザー対応の日報管理・共有Webアプリケーション。ユーザー同士のフォロー機能により、他のユーザーの日報を閲覧・学習できるソーシャル機能を搭載。

## 2. 技術スタック
- **フレームワーク**: Ruby on Rails 8.0
- **データベース**: MySQL
- **認証**: Devise
- **ページネーション**: Kaminari (20件/ページ)
- **テンプレート**: HAML
- **テスト**: RSpec
- **スタイリング**: Bootstrap 5

## 3. 機能要件

### 3.1 基本機能
- ユーザー登録・ログイン（Devise）
- プロフィール管理（ユーザー名、自己紹介など）
- 日報の作成・編集・削除・表示

### 3.2 日報項目
- **日付** (必須)
- **作業内容** (テキスト、文字数制限なし)
- **学んだ点** (テキスト、文字数制限なし)
- **もっとよくできる点** (テキスト、文字数制限なし)
- **公開設定** (公開/非公開)

### 3.3 ソーシャル機能
- **フォロー機能**
  - 他のユーザーをフォロー/アンフォロー
  - フォロワー・フォロー中ユーザー一覧
  - フォロー数・フォロワー数表示
- **他ユーザーの日報表示**
  - フォロー中ユーザーの公開日報閲覧
  - ユーザー別日報一覧
  - タイムライン機能（フォロー中ユーザーの最新日報）

### 3.4 一覧・表示機能
- 自分の日報一覧（テーブル形式）
- タイムライン（フォロー中ユーザーの日報）
- ユーザー検索・一覧
- ページネーション（20件/ページ）
- 検索機能（全文検索、ユーザー検索）
- フィルタリング機能（日付範囲、ユーザー別など）

### 3.5 関連機能
- **関連する学んだことの表示**
  - 日報詳細画面に実装
  - キーワードベースで関連する日報を表示
  - 「学んだ点」フィールドの内容でマッチング判定
  - 自分の日報だけでなく、フォロー中ユーザーの公開日報も対象

## 4. データベース設計

### 4.1 Usersテーブル（Devise標準 + 拡張）
- id
- email
- encrypted_password
- username (ユニーク、必須)
- display_name (表示名)
- bio (自己紹介)
- avatar_url (プロフィール画像URL)
- created_at, updated_at
- その他Deviseデフォルトフィールド

### 4.2 Daily Reportsテーブル
- id
- user_id (外部キー)
- date (日付)
- work_content (作業内容)
- learned_points (学んだ点)
- improvements (もっとよくできる点)
- is_public (公開フラグ、デフォルト: true)
- created_at, updated_at
- インデックス: [user_id, date] (ユニーク制約)

### 4.3 Followsテーブル
- id
- follower_id (外部キー: users.id)
- followee_id (外部キー: users.id)
- created_at, updated_at
- インデックス: [follower_id, followee_id] (ユニーク制約)

## 5. 画面設計

### 5.1 画面一覧
1. **認証関連**
   - ログイン画面
   - 新規登録画面
   - プロフィール編集画面

2. **日報関連**
   - 日報一覧画面（自分の日報）
   - タイムライン画面（フォロー中ユーザーの日報）
   - 日報詳細画面（関連日報表示含む）
   - 日報作成・編集画面

3. **ユーザー・フォロー関連**
   - ユーザー一覧画面
   - ユーザープロフィール画面
   - フォロワー・フォロー中ユーザー一覧画面

### 5.2 レイアウト
- Bootstrap 5によるレスポンシブ対応
- 統一されたナビゲーションヘッダー
- サイドバー（フォロー関連情報）
- モダンでクリーンなデザイン

## 6. URL設計
```
# 基本
GET    /                          # ダッシュボード（タイムラインへリダイレクト）
GET    /timeline                  # タイムライン画面

# 日報関連
GET    /daily_reports             # 自分の日報一覧
GET    /daily_reports/new         # 日報作成
POST   /daily_reports             # 日報作成処理
GET    /daily_reports/:id         # 日報詳細（関連日報表示含む）
GET    /daily_reports/:id/edit    # 日報編集
PATCH  /daily_reports/:id         # 日報更新
DELETE /daily_reports/:id         # 日報削除

# ユーザー関連
GET    /users                     # ユーザー一覧
GET    /users/:id                 # ユーザープロフィール・日報一覧
GET    /users/:id/followers       # フォロワー一覧
GET    /users/:id/following       # フォロー中一覧
GET    /profile/edit              # プロフィール編集
PATCH  /profile                   # プロフィール更新

# フォロー関連
POST   /users/:id/follow          # フォロー
DELETE /users/:id/follow          # アンフォロー

# 認証関連（Devise）
GET    /users/sign_in             # ログイン
GET    /users/sign_up             # 新規登録
POST   /users/sign_in             # ログイン処理
POST   /users                     # 新規登録処理
DELETE /users/sign_out            # ログアウト
```

## 7. セキュリティ要件
- Deviseによる認証・認可
- CSRF対策（Rails標準）
- SQLインジェクション対策（Active Record使用）
- XSS対策（ERB/HAML使用）
- **プライバシー保護**
  - 非公開日報は作成者のみ閲覧可能
  - フォローしていないユーザーの非公開日報は表示されない
- **認可制御**
  - 自分の日報のみ編集・削除可能
  - 他ユーザーの日報は閲覧のみ

## 8. パフォーマンス要件
- データベースインデックス最適化
  - users: username, email
  - daily_reports: [user_id, date], [user_id, is_public], learned_points (全文検索)
  - follows: [follower_id, followee_id]
- ページネーションによる大量データ対応
- 検索クエリの最適化
- N+1クエリ対策（includes使用）

## 9. 開発・テスト要件
- RSpecによる単体・統合テスト
  - モデルテスト（バリデーション、関連、スコープ）
  - コントローラーテスト（認証、認可）
  - 統合テスト（画面遷移、AJAX）
- Factory Botによるテストデータ作成
- Rubocopによるコード品質管理

## 10. 今後の拡張予定
- **通知機能**（新しいフォロワー、日報へのいいね）
- **いいね機能**（日報への評価）
- **コメント機能**（日報への感想・質問）
- **タグ機能**（日報のカテゴリー分け）
- **エクスポート機能**（PDF、CSV出力）
- **統計・分析機能**（学習の可視化）
- **API提供**（モバイルアプリ連携）
- **リアルタイム更新**（WebSocket使用）

## 11. Bootstrap活用方針
- **コンポーネント活用**
  - Card: 日報表示
  - Table: 一覧表示
  - Modal: 削除確認、詳細表示
  - Badge: フォロー数、公開状態
  - Button: アクション系
- **レイアウト**
  - Grid System: レスポンシブ対応
  - Navbar: ヘッダーナビゲーション
  - Sidebar: フォロー情報
- **フォーム**
  - Form Controls: 日報入力フォーム
  - Form Validation: クライアントサイド検証