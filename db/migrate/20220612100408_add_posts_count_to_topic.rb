class AddPostsCountToTopic < ActiveRecord::Migration[6.1]
  def up
    add_column :topics, :posts_count, :integer, default: 0

    ResetCounterQuery.call('topics', 'posts')
  end

  def down
    remove_column :topics, :posts_count
  end
end
