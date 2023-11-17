class Mention < ApplicationRecord
  belongs_to :mentioned
  belongs_to :mentioning
end
