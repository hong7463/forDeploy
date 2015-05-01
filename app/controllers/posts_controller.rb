class PostsController < ApplicationController
  before_action :find_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:show]
  def index
    @posts = Post.all.order("created_at DESC")
  end 

  def new
    @post = current_user.posts.build
    @user = current_user
  end 

  def create
    @post = current_user.posts.build(post_params)
    @user = current_user
    @posts = current_user.friend_posts.all.order('created_at DESC')

    if @post.save
      redirect_to root_path, notice: "Successfully created post"
    else 
      # render 'users/index'
      render 'users/index'
    end 
  end 

  def show
    @user = current_user
    @friends = current_user.friends.all
  end 

  def edit
    @user = current_user
    @circles = current_user.circles.all.order('circle_name')
  end 

  def update
    @user = current_user
    if @post.update(post_params)
      redirect_to user_post_path
    else 
      render 'edit'
    end 
  end 

  def destroy
    @post.destroy
    @user = current_user

    redirect_to @user
  end 

  private

  def post_params
    params.require(:post).permit(:text, :image, :location, :circle_id)
  end 

  def find_post
    @post = Post.find(params[:id])
  end 
end
