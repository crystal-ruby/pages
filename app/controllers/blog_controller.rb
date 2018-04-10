class BlogController < ApplicationController

  def index
      @pages = Page.pages
  end

  def page
    title = params[:title]
    return redirect_to(root_path) unless title
    @page = get_page(title)
    return redirect_to(root_path) unless @page
  end

  def get_page(title)
    page = Page.pages[title]
    #puts "No #{title} in #{Page.pages.keys.join(':')}"
    page
  end
end
