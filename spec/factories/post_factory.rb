FactoryBot.define do
  factory :post do
    content { Faker::Lorem.sentence }
    association :topic, factory: :topic
  end
end
