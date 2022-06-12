namespace :counter_cache do
  task reset: :environment do
    ResetCounterQuery.call('topics', 'posts')
  end
end
