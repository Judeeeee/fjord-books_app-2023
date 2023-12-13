# frozen_string_literal: true

class Mention < ApplicationRecord
  belongs_to :mentioned, class_name: 'Report'
  belongs_to :mentioning, class_name: 'Report'
  validates :mentioned, uniqueness: { scope: :mentioning }

  def self.insert_mentons(mentioning_report_ids, report)
    mentioning_report_ids.each do |mentioning_report_id|
      create(mentioned_id: report.id, mentioning_id: mentioning_report_id)
    end
  end
end
