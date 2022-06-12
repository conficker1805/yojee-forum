ActiveRecord::Base.connection.execute('TRUNCATE posts RESTART IDENTITY')
ActiveRecord::Base.connection.execute('TRUNCATE topics RESTART IDENTITY')
ActiveRecord::Base.connection.execute('TRUNCATE questions RESTART IDENTITY')

# Drop partitions
ActiveRecord::Base.connection.execute('DROP TABLE if exists quater_1_2022 cascade;')
ActiveRecord::Base.connection.execute('DROP TABLE if exists quater_2_2022 cascade;')
ActiveRecord::Base.connection.execute('DROP TABLE if exists quater_3_2022 cascade;')
ActiveRecord::Base.connection.execute('DROP TABLE if exists quater_4_2022 cascade;')

ActiveRecord::Base.connection.execute('DROP TABLE if exists posts_10k cascade;')
ActiveRecord::Base.connection.execute('DROP TABLE if exists posts_20k cascade;')
ActiveRecord::Base.connection.execute('DROP TABLE if exists posts_30k cascade;')
ActiveRecord::Base.connection.execute('DROP TABLE if exists posts_40k cascade;')
ActiveRecord::Base.connection.execute('DROP TABLE if exists posts_50k cascade;')
ActiveRecord::Base.connection.execute('DROP TABLE if exists posts_over_50k cascade;')

# Create partitions
Topic.create_partition(name: 'quater_1_2022',
                       start_range: Date.new(2022, 1, 1),
                       end_range: Date.new(2022, 4, 1))
Topic.create_partition(name: 'quater_2_2022',
                       start_range: Date.new(2022, 4, 1),
                       end_range: Date.new(2022, 7, 1))
Topic.create_partition(name: 'quater_3_2022',
                       start_range: Date.new(2022, 7, 1),
                       end_range: Date.new(2022, 10, 1))
Topic.create_partition(name: 'quater_4_2022',
                       start_range: Date.new(2022, 10, 1),
                       end_range: Date.new(2023, 1, 1))

Post.create_partition(start_range: 1, end_range: 10_000, name: 'posts_10k')
Post.create_partition(start_range: 10_000, end_range: 20_000, name: 'posts_20k')
Post.create_partition(start_range: 20_000, end_range: 30_000, name: 'posts_30k')
Post.create_partition(start_range: 30_000, end_range: 40_000, name: 'posts_40k')
Post.create_partition(start_range: 40_000, end_range: 50_000, name: 'posts_50k')
Post.create_partition(start_range: 50_000, end_range: 1_000_000_000_000, name: 'posts_over_50k')

def init_values
  (1..500_000).map do |i|
    date = "2022/#{(1..12).to_a.sample}/15"
    yield(i, date)
  end
end

# Create sample data
5.times do |x|
  # Create sample data for Topic
  values = init_values do |_, date|
    # rubocop:disable Style/StringConcatenation
    title = Faker::Movie.title.gsub('\'', '') + ' ' + Faker::Marketing.buzzwords.gsub('\'', '')
    # rubocop:enable Style/StringConcatenation
    "('#{title}', '#{date}')"
  end
  sql = 'INSERT INTO topics(title, created_at) VALUES '
  ActiveRecord::Base.connection.execute(sql + values.join(', '))

  # Create sample data for Post
  values = init_values do |i, _|
    content = Faker::Food.description.gsub("'", '')
    "('#{content}',#{i})"
  end
  sql = 'INSERT INTO posts(content, topic_id) VALUES '
  ActiveRecord::Base.connection.execute(sql + values.join(', '))

  # Create sample data for Question
  values = init_values do |i, date|
    content = Faker::Food.description.gsub("'", '')
    "('#{content}',#{i},'#{date}','#{date}')"
  end
  sql = 'INSERT INTO questions(content, topic_id, created_at, updated_at) VALUES '
  ActiveRecord::Base.connection.execute(sql + values.join(', '))
end


Topic.import(force: true)

Rake::Task['counter_cache:reset'].invoke
