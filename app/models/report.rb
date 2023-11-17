# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :mentioneds, class_name: "mentions", foreign_key: :mentioned_report_id, dependent: :destroy
  has_many :mentionings, class_name: "mentions", foreign_key: :mentioning_report_id, dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true
  validates_uniqueness_of :mentioned_report, scope: :mentioning_report

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end
end
