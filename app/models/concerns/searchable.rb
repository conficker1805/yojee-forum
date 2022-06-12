module Searchable
  extend ActiveSupport::Concern

  ES_INDEX = { number_of_shards: 2 }.freeze
  ES_ANALYSIS = {
    analyzer: {
      default: {
        type: :custom,
        tokenizer: :standard,
        filter: [:lowercase]
      }
    }
  }.freeze

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks
  end

  class_methods do
    def elastic_set_index
      settings index: ES_INDEX, analysis: ES_ANALYSIS do
        yield if block_given?
      end
    end
  end
end
