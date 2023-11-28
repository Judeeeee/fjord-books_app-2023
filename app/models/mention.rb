# frozen_string_literal: true

class Mention < ApplicationRecord
  belongs_to :mentioned, class_name: 'Report'
  belongs_to :mentioning, class_name: 'Report'
  validates :mentioned, uniqueness: { scope: :mentioning }

  def self.insert_mentons(mentioning_reports, report)
    mentioning_reports.each do |mentioning_report|
      create(mentioned_id: report.id, mentioning_id: mentioning_report)
    end
  end

  def self.update_mentions(report)
    mentioned_report_ids = where(mentioned_id: report.id).pluck(:mentioning_id)
    updated_mentioned_report_ids = report.mentioning_report_links

    add_ids = updated_mentioned_report_ids - mentioned_report_ids
    del_ids = mentioned_report_ids - updated_mentioned_report_ids

    ActiveRecord::Base.transaction do
      unless del_ids.empty?
        del_ids.each do |del_id|
          target_report = where(mentioned_id: report.id, mentioning_id: del_id).first.id
          destroy(target_report)
        end
      end

      unless add_ids.empty?
        add_ids.each do |add_id|
          create(mentioned_id: report.id, mentioning_id: add_id)
        end
      end
    end
  end
end
