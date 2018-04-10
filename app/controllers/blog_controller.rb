class BlogController < ApplicationController

  def index
    @posts = Post.posts
  end

  def post
    title = params[:title]
    return redirect_to(root_path) unless title
    @post = get_post(title)
    return redirect_to(root_path) unless @post
  end

  def get_post(title)
    post = Post.posts[title]
    #puts "No #{title} in #{Post.posts.keys.join(':')}"
    post
  end
end
