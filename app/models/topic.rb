class Topic < ApplicationRecord
  self.primary_key = 'id'

  # Table partition
  range_partition_by { '(created_at::date)' }

  # Validations
  validates :title, length: { in: 1..140 }

  # Association
  has_many :posts, dependent: :destroy
  has_many :questions, dependent: :destroy
end
