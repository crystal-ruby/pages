class Post
  @@posts = nil

  attr_reader :year , :month , :day , :dir , :ext

  def initialize(path)
    @dir = File.dirname(path)
    base , @ext = File.basename(path).split(".")
    raise "must be partial, start with _ not:#{base}" unless base[0] == "_"
    @words = base.split("-")
    @year = parse_int(@words.shift[1 .. -1] , 2100)
    @month = parse_int(@words.shift , 12)
    @day = parse_int(@words.shift , 32)
    raise "Invalid path #{path}" unless @words
  end

  def slug
    @words.join("-").downcase
  end
  def title
    @words.join(" ")
  end
  def template_name
    "#{date}-#{@words.join("-")}"
  end
  def date
    "#{year}-#{month}-#{day}"
  end
  def parse_int( value , max)
    ret = value.to_i
    raise "invalid value #{value} > #{max}" if ret > max or ret < 1
    ret
  end
  def content
    File.open("#{@dir}/_#{template_name}.#{ext}" ).read
  end
  def summary
    ret = content.split("%h2").first.gsub("%p", "<br/>").html_safe
    ret[0 .. 400]
  end
  def self.posts
    return @@posts if @@posts
    posts ={}
    Dir["#{self.blog_path}/_2*.haml"].reverse.each do |file|
      post = Post.new(file)
      posts[post.slug] = post
    end
    @@posts = posts.sort_by { |slug, post| post.sort_key }.reverse.to_h
  end

  def sort_key
    year*10000 + month*1000 + day
  end

  def self.blog_path
    Rails.configuration.blog_path
  end
end
