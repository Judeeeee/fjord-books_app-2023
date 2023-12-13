# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :mentioneds, class_name: 'Mention', foreign_key: :mentioned_id, dependent: :destroy, inverse_of: :mentioned
  has_many :mentionings, class_name: 'Mention', foreign_key: :mentioning_id, dependent: :destroy, inverse_of: :mentioned

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def retrieve_report_link
    report_links = content.scan(%r{http://localhost:3000/reports/(\d+)})
    report_links.flatten.map(&:to_i)
  end

  def links_update?
    mentioned_report_ids = Mention.where(mentioned_id: id).pluck(:mentioning_id)
    mentioned_report_ids != retrieve_report_link
  end

  def update_mentions
    mentioned_report_ids = Mention.where(mentioned_id: self.id).pluck(:mentioning_id)
    updated_mentioned_report_ids = self.retrieve_report_link

    add_ids = updated_mentioned_report_ids - mentioned_report_ids
    del_ids = mentioned_report_ids - updated_mentioned_report_ids

    ActiveRecord::Base.transaction do
      if del_ids.any?
        del_ids.each do |del_id|
          target_report = Mention.where(mentioned_id: self.id, mentioning_id: del_id).first.id
          Mention.destroy(target_report)
        end
      end

      if add_ids.any?
        add_ids.each do |add_id|
          Mention.create(mentioned_id: self.id, mentioning_id: add_id)
        end
      end
    end
  end
end
