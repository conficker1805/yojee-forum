class BootstrapDatabase < ActiveRecord::Migration[6.1]
  def up
    create_table :questions do |t|
      t.string :content, null: false
      t.references :topic, null: false, index: true
      t.timestamps null: false
    end

    execute <<-SQL
      CREATE TABLE topics (
        id bigserial NOT NULL,
        title character varying(255) NOT NULL,
        created_at timestamp NOT NULL
      ) PARTITION BY RANGE (created_at);

      CREATE INDEX index_topics_on_id ON Topics(id);

      CREATE TABLE posts (
        id bigserial NOT NULL,
        topic_id bigserial NOT NULL,
        content text NOT NULL
      ) PARTITION BY RANGE (topic_id);

      CREATE INDEX index_posts_on_id ON Posts(id);
      CREATE INDEX index_posts_on_topic_id ON Posts(topic_id);
    SQL

    unless Rails.env.test?
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
    end
  end

  def down
    unless Rails.env.test?
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

      ActiveRecord::Base.connection.execute("DROP TABLE if exists posts cascade;")
      ActiveRecord::Base.connection.execute("DROP TABLE if exists topics cascade;")
      ActiveRecord::Base.connection.execute("DROP TABLE if exists questions cascade;")
    end
  end
end
