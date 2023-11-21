class Mention < ApplicationRecord
  belongs_to :mentioned, class_name: "Report", foreign_key: :report_id
  belongs_to :mentioning, class_name: "Report", foreign_key: :report_id
  validates_uniqueness_of :mentioned, scope: :mentioning
end
