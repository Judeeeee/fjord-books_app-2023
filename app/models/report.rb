# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :mentioneds, class_name: "Report", foreign_key: :mentioned_report_id, dependent: :destroy
  has_many :mentionings, class_name: "Report", foreign_key: :mentioning_report_id, dependent: :destroy

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

  def delete_relationship
    # 更新 => 日報リンク一覧取得 => テーブルのレコードと一覧を比較 => (データ数が減っていたら)削除
    # 両配列を比較して、重複していないものを取得する。(引き算で取得できる。)
    # idを取得して、Mention.deteteする。

    if  Mention.where(mentioned_report_id: @report.id, mentioning_report_id: @report.id).size > @report.mentioning.size
      deletable_item = Mention.where(mentioned_report_id: @report.id, mentioning_report_id: @report.id).size - @report.mentioning
      Mention.delete(deletable_item.id)
    end
  end
end
