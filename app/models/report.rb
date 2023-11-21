# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :mentioneds, foreign_key: :mentioned_id, dependent: :destroy
  has_many :mentionings, foreign_key: :mentioning_id, dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def mentioning
    report_links = self.content.scan(/http:\/\/localhost:3000\/reports\/(\d+)|^params[:id]/)
    report_links.flatten.map(&:to_i)
  end
end
