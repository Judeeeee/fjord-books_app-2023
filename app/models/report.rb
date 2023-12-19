# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :mentioneds, class_name: 'Mention', foreign_key: :mentioned_id, dependent: :destroy, inverse_of: :mentioned
  has_many :mentionings, class_name: 'Mention', foreign_key: :mentioning_id, dependent: :destroy, inverse_of: :mentioning

  has_many :mentioning_reports, through: :mentionings, source: :mentioned
  has_many :mentioned_reports, through: :mentioneds, source: :mentioning

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def retrieve_report_link
    report_links = content.scan(%r{http://localhost:3000/reports/(\d+)}).uniq
    report_links.flatten.map(&:to_i)
  end

  def need_to_update_mentionings?
    mentionings.pluck(:mentioned_id) != retrieve_report_link
  end

  def update_mentions
    before_report_ids = mentionings.pluck(:mentioned_id)
    after_report_ids = retrieve_report_link

    add_report_ids = after_report_ids - before_report_ids
    del_report_ids = before_report_ids - after_report_ids

    ActiveRecord::Base.transaction do
      if del_report_ids.any?
        del_report_ids.each do |del_report_id|
          target_report = Mention.where(mentioned_id: del_report_id, mentioning_id: id).first.id
          Mention.destroy(target_report)
        end
      end

      if add_report_ids.any?
        add_report_ids.each do |add_report_id|
          Mention.create(mentioned_id: add_report_id, mentioning_id: id)
        end
      end
    end
  end
end
