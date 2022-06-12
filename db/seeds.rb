# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with
# db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def init_values
  (1..500_000).map do |i|
    date = "2022/#{(1..12).to_a.sample}/15"
    yield(i, date)
  end
end

ActiveRecord::Base.connection.execute('TRUNCATE posts RESTART IDENTITY')
ActiveRecord::Base.connection.execute('TRUNCATE topics RESTART IDENTITY')
ActiveRecord::Base.connection.execute('TRUNCATE questions RESTART IDENTITY')

# Drop partitions if exist
ActiveRecord::Base.connection.execute("DROP TABLE if exists quater_1_2022 cascade;")
ActiveRecord::Base.connection.execute("DROP TABLE if exists quater_2_2022 cascade;")
ActiveRecord::Base.connection.execute("DROP TABLE if exists quater_3_2022 cascade;")
ActiveRecord::Base.connection.execute("DROP TABLE if exists quater_4_2022 cascade;")

ActiveRecord::Base.connection.execute("DROP TABLE if exists posts_10k cascade;")
ActiveRecord::Base.connection.execute("DROP TABLE if exists posts_20k cascade;")
ActiveRecord::Base.connection.execute("DROP TABLE if exists posts_30k cascade;")
ActiveRecord::Base.connection.execute("DROP TABLE if exists posts_40k cascade;")
ActiveRecord::Base.connection.execute("DROP TABLE if exists posts_50k cascade;")
ActiveRecord::Base.connection.execute("DROP TABLE if exists posts_over_50k cascade;")

# Create partitions
Topic.create_partition(name: 'quater_1_2022', start_range: Date.new(2022, 1, 1),  end_range: Date.new(2022, 4, 1))
Topic.create_partition(name: 'quater_2_2022', start_range: Date.new(2022, 4, 1),  end_range: Date.new(2022, 7, 1))
Topic.create_partition(name: 'quater_3_2022', start_range: Date.new(2022, 7, 1),  end_range: Date.new(2022, 10, 1))
Topic.create_partition(name: 'quater_4_2022', start_range: Date.new(2022, 10, 1), end_range: Date.new(2023, 1, 1))

Post.create_partition(start_range: 1, end_range: 10_000, name: 'posts_10k')
Post.create_partition(start_range: 10_000, end_range: 20_000, name: 'posts_20k')
Post.create_partition(start_range: 20_000, end_range: 30_000, name: 'posts_30k')
Post.create_partition(start_range: 30_000, end_range: 40_000, name: 'posts_40k')
Post.create_partition(start_range: 40_000, end_range: 50_000, name: 'posts_50k')
Post.create_partition(start_range: 50_000, end_range: 1_000_000_000_000, name: 'posts_over_50k')

# Create sample data
10.times do |x|
  Rails.logger.info("--- Batch #{x}")

  # Create sample data for Topic
  values = init_values { |_, date| "('#{Faker::Marketing.buzzwords}', '#{date}')" }
  sql = 'INSERT INTO topics(title, created_at) VALUES '
  ActiveRecord::Base.connection.execute(sql + values.join(', '))

  # Create sample data for Post
  values = init_values { |i, _| "(#{i},#{i})" }
  sql = 'INSERT INTO posts(content, topic_id) VALUES '
  ActiveRecord::Base.connection.execute(sql + values.join(', '))

  # Create sample data for Question
  values = init_values { |i, date| "('#{Faker::Lorem.sentence}',#{i},'#{date}','#{date}')" }
  sql = 'INSERT INTO questions(content, topic_id, created_at, updated_at) VALUES '
  ActiveRecord::Base.connection.execute(sql + values.join(', '))
end
