class Mention < ApplicationRecord
  belongs_to :mentioned
  belongs_to :mentioning
  validates_uniqueness_of :mentioned_report_id, scope: :mentioning_report_id
end
