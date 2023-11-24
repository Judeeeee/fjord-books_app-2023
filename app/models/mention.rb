class Mention < ApplicationRecord
  belongs_to :mentioned, class_name: "Report"
  belongs_to :mentioning, class_name: "Report"
  validates_uniqueness_of :mentioned, scope: :mentioning

  def self.insert_mentons(mentioning_reports, report)
    mentioning_reports.each do |mentioning_report|
      mention =  self.new(mentioned_id: report.id, mentioning_id: mentioning_report)
      mention.save
    end
  end

  def self.delete_mentions(report)
    # 中間テーブルに保存されているレコードから言及先の日報IDを取得する。
    db_ids = Mention.where(mentioned_id: @report.id).map{|mention| mention.mentioning_id}
    deletable_items = db_ids - @report.mentioning
    deletable_items.each do |deletable_item|
      foo = Mention.where(mentioned_id: @report.id, mentioning: deletable_item).first.id
      Mention.delete(foo)
    end
  end

  def self.links_update?(report)
    self.where(mentioned_id: report.id).size > report.mentioning_report_links.size
  end
end
