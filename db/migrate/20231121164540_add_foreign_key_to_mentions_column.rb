class AddForeignKeyToMentionsColumn < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :mentions, :reports, column: :mentioned
    add_foreign_key :mentions, :reports, column: :mentioning
  end
end
