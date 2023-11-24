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
    updated_mentioned_report_ids = report.mentioning_report_links

    add_ids = updated_mentioned_report_ids - mentioned_report_ids
    del_ids = mentioned_report_ids - updated_mentioned_report_ids

    #トランザクションを貼る
    ActiveRecord::Base.transaction do
      unless del_ids.empty?
        # del_ids を使ってDELETE
        del_ids.each do |del_id|
          target_report = Mention.where(mentioned_id: report.id, mentioning_id: del_id).first.id
          Mention.delete(target_report)
        end
      end

      unless add_ids.empty?
        # add_ids を使ってINSERT
        add_ids.each do |add_id|
          target_report = Mention.new(mentioned_id: report.id, mentioning_id: add_id)
          target_report.save
        end
      end
    end
  end

  def self.links_update?(report)
    # 中間テーブルのレコードと本文のリンクに違いがあるときにtrueを返したい
    mentioned_report_ids = self.where(mentioned_id: report.id).map{|mention| mention.mentioning_id}
    mentioned_report_ids != (report.mentioning_report_links)
  end
end
