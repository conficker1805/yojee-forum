class Post < ApplicationRecord
  self.primary_key = 'id'

  # Table partition
  range_partition_by :topic_id

  # Associations
  belongs_to :topic, counter_cache: true
end
