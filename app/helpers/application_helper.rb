module ApplicationHelper
  def post_link(index)
    post = Post.posts.values[index]
    return "" unless post
    link = post.date.to_s + "  "
    link +=  link_to( post.title , blog_post_url(post.slug))
    link.html_safe
  end


  def ext_link(name = nil, options = nil, html_options = nil, &block)
    target_blank = {target: "_blank"}
    if block_given?
      options ||= {}
      options = options.merge(target_blank)
    else
      html_options ||= {}
      html_options = html_options.merge(target_blank)
    end
    link_to(name, options, html_options, &block)
  end
end
