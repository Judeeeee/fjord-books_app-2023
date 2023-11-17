class CreateMentions < ActiveRecord::Migration[7.0]
  def change
    create_table :mentions do |t|
      t.integer :mentioned_report_id, null: false, foreign_key: true
      t.integer :mentioning_report_id, null: false, foreign_key: true
      t.timestamps
    end
    add_index :mentions, [:mentioned_report_id, :mentioning_report_id], unique: true
  end
end
