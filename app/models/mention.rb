# frozen_string_literal: true

class Mention < ApplicationRecord
  belongs_to :mentioned, class_name: 'Report'
  belongs_to :mentioning, class_name: 'Report'
  validates :mentioned, uniqueness: { scope: :mentioning }
end
