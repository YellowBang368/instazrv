class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action -> { relationship_exists? params[:id] }, only: [:destroy_relationship]

  def create_relationship
    @user = User.find(params[:id])
    current_user.follow(@user)
    if current_user.follows?(@user)
      respond_to do |format|
        format.html { flash.now[:success] = "SUCCESS" }
        format.js { render "users/render_follow" }
      end
    end
  end

  def destroy_relationship
    @user = User.find(params[:id])
    current_user.unfollow(@user)
    unless current_user.follows?(@user)
      respond_to do |format|
        format.html { flash.now[:success] = "SUCCESS" }
        format.js { render "users/render_follow" }
      end
    end
  end

  private
  def relationship_exists?(id)
    Relationship.where(follower_id: current_user.id, followed_id: id).count == 1
  end
end
