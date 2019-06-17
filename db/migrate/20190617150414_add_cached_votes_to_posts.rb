class AddCachedVotesToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :cached_votes_total, :integer, default: 0
    Post.find_each(&:update_cached_votes)
  end
end
