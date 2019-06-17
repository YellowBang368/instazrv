class AddPostsCountToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :posts_counter, :integer, default: 0
    User.reset_column_information
    User.find_each do |user|
      User.update_counters user.id, posts_counter: user.posts.count
    end
  end
end
