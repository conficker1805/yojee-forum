class Post < ApplicationRecord
  self.primary_key = 'id'

  # Table partition
  range_partition_by :topic_id

  # Associations
  belongs_to :topic, counter_cache: true

  # Validation
  validates :content, presence: true
  validates :content, length: { maximum: 10_000 }
end
