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
end
