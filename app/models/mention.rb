class Mention < ApplicationRecord
  belongs_to :mentioned, class_name: "Report"
  belongs_to :mentioning, class_name: "Report"
  validates_uniqueness_of :mentioned, scope: :mentioning
end
