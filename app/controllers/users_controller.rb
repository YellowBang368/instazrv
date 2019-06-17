class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :force_json, only: :search
  def feed
    @feed_posts = get_feed
    @suggested_users = get_suggested_users(@feed_posts.count > 0 ? 5 : 15)
    @followings = current_user.followings

    # Unwrapping comments in all threads
    @feed_posts.each do |post|
      commontator_thread_show(post)
    end
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.get_posts
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

  def get_feed
    Post.where('user_id IN (?)', current_user.followings.ids << current_user.id)
    .includes(thread: ["comments"])
  end

  def get_suggested_users(limit)
    User.order(followers_counter: :desc)
    .where.not('id IN (?)', current_user.followings.ids)
    .all_except(current_user)
    .limit(limit)
  end

  def force_json
    request.format = :json
  end
end
