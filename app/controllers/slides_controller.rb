class SlidesController < ApplicationController

  def index
    render( template: "slides/#{params[:slide]}" ,   layout: false )
  end

end
