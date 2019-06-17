class AddFollowersAndFollowingsCounterToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :followers_counter, :integer, default: 0
    add_column :users, :followings_counter, :integer, default: 0
    User.find_each do |user|
      User.update_counters user.id, followers_counter: user.followers.count, followings_counter: user.followings.count
    end
  end
end
