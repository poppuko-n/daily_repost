class CreateDailyReports < ActiveRecord::Migration[8.0]
  def change
    create_table :daily_reports do |t|
      t.references :user, null: false, foreign_key: true
      t.date :date, null: false
      t.text :work_content
      t.text :learned_points
      t.text :improvements
      t.boolean :is_public, default: true, null: false

      t.timestamps
    end

    add_index :daily_reports, [:user_id, :date], unique: true
    add_index :daily_reports, [:user_id, :is_public]
    add_index :daily_reports, :learned_points, type: :fulltext
  end
end
