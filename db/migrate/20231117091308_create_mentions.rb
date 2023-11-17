class CreateMentions < ActiveRecord::Migration[7.0]
  def change
    create_table :mentions do |t|
      t.string :mentioned_report_id
      t.string :mentioning_report_id

      t.timestamps
    end
  end
end
