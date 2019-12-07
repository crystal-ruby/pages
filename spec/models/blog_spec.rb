require 'rails_helper'

RSpec.describe Post, type: :model do

  describe "creation" do
    it "ok with valid slug" do
      post = Post.new("1993/_2-4-title")
      expect(post).not_to eq nil
    end
    it "raises with invalid slug" do
      expect{Post.new("1993/_4-title")}.to raise_error RuntimeError
    end
    it "must start with a year" do
      expect{Post.new("no-num/_4-title")}.to raise_error RuntimeError
    end
    it "must start with a underscore" do
      expect{Post.new("1999/4-4-title")}.to raise_error RuntimeError
    end
  end

  describe "basic api" do
    before :each do
      @post = Post.new("1993/_2-4-title.haml")
    end
    it "returns title" do
      expect(@post.title).to eq "title"
    end
    it "returns dates" do
      expect(@post.year).to eq 1993
      expect(@post.day).to eq 4
      expect(@post.month).to eq 2
    end
    it "returns date" do
      expect(@post.date).to eq Date.new(1993,2,4)
    end
    it "returns file_name" do
      expect(@post.template_name).to eq "1993/02-04-title"
    end
  end

  describe "precise api definition" do
    it "returns whole title" do
      post = Post.new("1993/_2-4-Multi-word-title")
      expect(post.title).to eq "Multi word title"
    end
    it "returns slug" do
      post = Post.new("1993/_2-4-Multi-word-title")
      expect(post.slug).to eq "multi-word-title"
    end
    it "returns title without extension if given file name" do
      post = Post.new("1993/_2-4-title.rb")
      expect(post.title).to eq "title"
    end
    it 'slugs are downcase' do
      post = Post.new("1993/_2-4-Multi-word-title")
      slug = post.slug
      expect(slug.downcase).to eq slug
    end
  end

  describe "post list" do
    before :each do
      @posts = Post.posts
      @first = @posts.values.first
    end
    it "reads config path" do
      expect(Post.blog_path.include?("app")).to eq true
    end
    it "first post has content" do
      expect(@posts.values.first).not_to be_nil
      expect(@posts.values.first.content.length).to be > 10
    end
    it "return a list of posts" do
      expect(@posts.class).to eq Hash
      expect(@posts.length).to be > 0
    end
    it "post template exists" do
      file = Post.blog_path + "/" + @first.template_file + ".haml"
      expect(File.exists?(file)).to eq true
    end
  end
end
