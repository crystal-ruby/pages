module ApplicationHelper
  def post_link(index)
    post = Post.posts.values[index]
    return "" unless post
    link = post.date.to_s + "  "
    link +=  link_to( post.title , blog_post_url(post.slug))
    link.html_safe
  end
end
