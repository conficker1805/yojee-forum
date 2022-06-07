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
  end

  def down
    ActiveRecord::Base.connection.execute("DROP TABLE if exists posts cascade;")
    ActiveRecord::Base.connection.execute("DROP TABLE if exists topics cascade;")
    ActiveRecord::Base.connection.execute("DROP TABLE if exists questions cascade;")
  end
end
