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

  def mentioning_report_links
    report_links = content.scan(%r{http://localhost:3000/reports/(\d+)})
    report_links.flatten.map(&:to_i)
  end

    def links_update?
      # 中間テーブルのレコードと本文のリンクに違いがあるときにtrueを返したい
      mentioned_report_ids = Mention.where(mentioned_id: self.id).pluck(:mentioning_id)
      mentioned_report_ids != (self.mentioning_report_links)
    end
end
