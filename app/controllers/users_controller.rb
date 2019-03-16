class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action -> { relationship_exists? params[:id] }, only: [:destroy_relationship]

  def feed
    if user_signed_in?
      @feed_posts = []
      following_users = current_user.following + [current_user]
      following_users.each do |following|
        following.posts.each do |post|
          @feed_posts << post
        end
      end
    end
    @feed_posts.reverse!
    @feed_posts.each do |post|
      commontator_thread_show(post)
    end
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(:created_at).reverse_order
  end

  def create_relationship
    Relationship.create(follower_id: current_user.id, followed_id: params[:id])
    redirect_back(fallback_location: root_path)
  end

  def destroy_relationship
    Relationship.where(follower_id: current_user.id, followed_id: params[:id]).first.destroy
    redirect_back(fallback_location: root_path)
  end

  private
  def user_params
    params.require(:user).permit(:id)
  end

  def signed_in
    redirect_back(fallback_location: root_path) unless user_signed_in?
  end

  def relationship_exists?(id)
    Relationship.where(follower_id: current_user.id, followed_id: id).count == 1
  end

  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation)
  end
end
