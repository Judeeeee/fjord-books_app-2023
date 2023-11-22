class ChangeColumnNameInMentions < ActiveRecord::Migration[7.0]
  def change
    rename_column :mentions, :mentioned, :mentioned_id
    rename_column :mentions, :mentioning, :mentioning_id
  end
end
