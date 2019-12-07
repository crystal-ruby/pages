class Post
  @@posts = nil

  attr_reader :year , :month , :day , :ext

  def initialize(path)
    year , rest = *path.split("/")
    @year = parse_int(year , 2100 , "year")
    base , @ext = File.basename(rest).split(".")
    raise "must be partial, start with _ not:#{base}" unless base[0] == "_"
    @words = base.split("-")
    raise "Invalid path #{path}" unless @words
    @month = parse_int(@words.shift[1 .. -1] , 12 , "month")
    @day = parse_int(@words.shift , 32 , "week")
  end

  def slug
    @words.join("-").downcase
  end
  def title
    @words.join(" ")
  end
  def template_name
    "#{year}/#{month.to_s.rjust(2, '0')}-#{day.to_s.rjust(2, '0')}-#{@words.join("-")}"
  end
  def template_file
    "#{year}/_#{month.to_s.rjust(2, '0')}-#{day.to_s.rjust(2, '0')}-#{@words.join("-")}"
  end
  def date
    Date.new(year,month,day)
  end
  def parse_int( value , max , name)
    ret = value.to_i
    raise "invalid #{name} #{value} > #{max}" if ret > max or ret < 1
    ret
  end
  def content
    File.open("#{self.class.blog_path}/#{template_file}.#{ext}" ).read
  end
  def summary
    ret = content.split("%h2").first.gsub("%p", "<br/>").html_safe
    ret[0 .. 400]
  end
  def self.posts
    return @@posts if @@posts
    posts ={}
    Dir["#{self.blog_path}/2*/_*.haml"].reverse.each do |file|
      parts = file.split("/")
      post_name = parts[-2] + "/" + parts[-1]
      post = Post.new(post_name)
      posts[post.slug] = post
    end
    @@posts = posts.sort_by { |slug, post| post.sort_key }.reverse.to_h
  end

  def sort_key
    year*1000 + month*10 + day
  end

  def self.blog_path
    Rails.configuration.blog_path
  end
end
