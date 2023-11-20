class Mention < ApplicationRecord
  has_many :reports
  validates_uniqueness_of :mentioned_report_id, scope: :mentioning_report_id
end
