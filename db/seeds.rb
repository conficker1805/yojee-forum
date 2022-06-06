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

10.times do |x|
  Rails.logger.info("--- Batch #{x}")

  # Create sample data for Topic
  values = init_values { |i, date| "(#{i}, '#{date}')" }
  sql = 'INSERT INTO topics(title, created_at) VALUES '
  ActiveRecord::Base.connection.execute(sql + values.join(', '))

  # Create sample data for Post
  values = init_values { |i, _| "(#{i},#{i})" }
  sql = 'INSERT INTO posts(content, topic_id) VALUES '
  ActiveRecord::Base.connection.execute(sql + values.join(', '))

  # Create sample data for Question
  values = init_values { |i, date| "(#{i},#{i},'#{date}','#{date}')" }
  sql = 'INSERT INTO questions(content, topic_id, created_at, updated_at) VALUES '
  ActiveRecord::Base.connection.execute(sql + values.join(', '))
end
