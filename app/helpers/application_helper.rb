module ApplicationHelper
  def post_link(post)
    return "" unless post
    link_to(blog_post_url(post.slug)) do
      "#{post.title.capitalize} <span>(#{post.date})</span>".html_safe
    end.html_safe
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

  def title(title)
    @title = title
  end

  def prev_post(post)
    index = Post.posts.keys.index(post.slug)
    nav_post(index + 1 , "prev")
  end
  def next_post(post)
    index = Post.posts.keys.index(post.slug)
    nav_post(index - 1 , "next")
  end
  def nav_post(index, dir)
    return "" unless index >= 0
    post = Post.posts.values[index]
    return "" unless post
    link_to("#{dir} <span>(#{post.date})</span>".html_safe , blog_post_url(post.slug) , alt: post.title.capitalize)
  end
end
