class RenameMentionsColumn < ActiveRecord::Migration[7.0]
  def change
    rename_column :mentions, :mentioned_report_id, :mentioned
    rename_column :mentions, :mentioning_report_id, :mentioning
  end
end
