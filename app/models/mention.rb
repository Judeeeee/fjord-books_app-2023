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
    mentioned_report_ids = Mention.where(mentioned_id: report.id).map{|mention| mention.mentioning_id}
    delete_taeget_reports = mentioned_report_ids - report.mentioning
    delete_taeget_reports.each do |delete_taeget_report|
      report = Mention.where(mentioned_id: report.id, mentioning: delete_taeget_report).first.id
      Mention.delete(report)
    end
  end

  def self.links_update?(report)
    self.where(mentioned_id: report.id).size > report.mentioning_report_links.size
  end
end
