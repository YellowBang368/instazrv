class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action -> { relationship_exists? params[:id] }, only: [:destroy_relationship]

  def feed
    if user_signed_in?
      @feed_posts = []
      current_user.following.each do |following|
        following.posts.each do |post|
          @feed_posts << post
        end
      end
    end
  end

  def show
    @user = User.find(params[:id])
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
end
