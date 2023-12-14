class CreateMentions < ActiveRecord::Migration[7.0]
  def change
    create_table :mentions do |t|
      t.integer :mentioned_id, null: false
      t.integer :mentioning_id, null: false
      t.timestamps
    end
    add_index :mentions, [:mentioned_id, :mentioning_id], unique: true
    add_foreign_key :mentions, :reports, column: :mentioned_id
    add_foreign_key :mentions, :reports, column: :mentioning_id
  end
end
