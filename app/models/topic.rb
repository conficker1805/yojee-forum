require 'elasticsearch/model'

class Topic < ApplicationRecord
  include Searchable

  self.primary_key = 'id'

  # Table partition
  range_partition_by { '(created_at::date)' }

  # Validations
  validates :title, length: { in: 1..140 }

  # Association
  has_many :posts, dependent: :destroy
  has_many :questions, dependent: :destroy

  # Elastic Search
  elastic_set_index do
    mappings dynamic: 'false' do
      indexes :title, analyzer: 'english'
    end
  end
end
