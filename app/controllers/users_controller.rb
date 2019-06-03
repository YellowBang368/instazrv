class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
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
    @feed_posts = @feed_posts.reverse!

    # Unwrapping comments in all threads
    @feed_posts.each do |post|
      commontator_thread_show(post)
    end
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(:created_at).reverse_order
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

  private
  def user_params
    params.require(:user).permit(:id, :name, :password, :password_confirmation)
  end

  def force_json
    request.format = :json
  end
end
