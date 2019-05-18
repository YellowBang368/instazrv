class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action -> { relationship_exists? params[:id] }, only: [:destroy_relationship]
  before_action :force_json, only: :search
  def feed
    # Suggested users to follow
    @suggested_users = User.all.sort_by(&:posts_count).reverse
    @suggested_users = @suggested_users.reject {|u| u.followers.include?(current_user)}
    @suggested_users.delete(current_user)

    # Feed initalizing
    @feed_posts = []
    following_users = current_user.following + [current_user]
    following_users.each do |following|
      following.posts.each do |post|
        @feed_posts << post
      end
    end
    @feed_posts = @feed_posts.reverse!.take(6)

    # Unwrapping comments in all threads
    @feed_posts.each do |post|
      commontator_thread_show(post)
    end
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(:created_at).reverse_order
  end

  def edit
    render(:layout => "layouts/application")
  end

  def change_avatar
    respond_to do |format|
      format.js
    end
  end

  def search
    @users = User.ransack(username_cont: params[:q]).result(distinct: false)
    respond_to do |format|
      format.html
      format.json {
        @users
      }
    end
  end

  def create_relationship
    @user = User.find(params[:id])
    Relationship.create(follower_id: current_user.id, followed_id: params[:id])
    respond_to do |format|
      format.html { flash.now[:success] = "SUCCESS" }
      format.js { render "render_follow" }
    end
  end

  def destroy_relationship
    @user = User.find(params[:id])
    Relationship.where(follower_id: current_user.id, followed_id: params[:id]).first.destroy
    respond_to do |format|
      format.html { flash.now[:success] = "SUCCESS" }
      format.js { render "render_follow" }
    end
  end

  private
  def relationship_exists?(id)
    Relationship.where(follower_id: current_user.id, followed_id: id).count == 1
  end

  def user_params
    params.require(:user).permit(:id, :name, :password, :password_confirmation)
  end

  def force_json
    request.format = :json
  end
end
