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

    # 配列サイズが違っていたら削除、同じだったら更新
    if mentioned_report_ids.size == report.mentioning_report_links
      # 更新
      mentioned_report_ids.each do |mentioned_report_id|
        update_target_report = Mention.where(mentioned_id: report.id, mentioning: mentioned_report_id).first.id
        report.mentioning_report_links.each do |mentioning_report_link|
          update_target_report.update(mentioning_id: mentioning_report_link)
        end
      end
    else
      # 削除
      delete_taeget_reports = mentioned_report_ids - report.mentioning_report_links
      delete_taeget_reports.each do |delete_taeget_report|
        report = Mention.where(mentioned_id: report.id, mentioning: delete_taeget_report).first.id
        Mention.delete(report)
      end
    end
  end

  def self.links_update?(report)
    # 中間テーブルのレコードと本文のリンクに違いがあるときにtrueを返したい
    mentioned_report_ids = self.where(mentioned_id: report.id).map{|mention| mention.mentioning_id}
    mentioned_report_ids != (report.mentioning_report_links)
  end
end
