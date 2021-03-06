class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
    commontator_thread_show(@post)
    respond_to do |format|
      format.html {
        redirect_to @post.user
      }
      # Show post on click
      # format.js
    end
  end

  # GET /posts/new
  def new
    @post = Post.new
    respond_to do |format|
      format.js
    end
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.user = current_user
      if @post.save
        respond_to do |format|
          format.html { render :crop }
          format.js { render :crop, remote: true }
          format.json { render :show, status: :created, location: @post }
        end
      else
        respond_to do |format|
          format.html {
            flash.alert = "true"
            flash.notice = "Couldn't upload this image. Try again"
            redirect_to current_user
          }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    if @post.update(post_params)
      respond_to do |format|
        format.html { redirect_to @post }
        format.json { render :show, status: :ok, location: @post }
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def create_like
    post = Post.find(params[:id])
    post.liked_by current_user
    respond_to do |format|
      format.js {
        @post = Post.find(params[:id])
        @likes_count = @post.get_likes.size
        render "render_like"
      }
    end
  end

  def destroy_like
    post = Post.find(params[:id])
    post.unliked_by current_user
    respond_to do |format|
      format.js {
        @post = Post.find(params[:id])
        @likes_count = @post.get_likes.size
        render "render_like"
      }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit( :crop_x, :crop_y, :crop_w, :crop_h, :desc, :address, :images)
    end
end
