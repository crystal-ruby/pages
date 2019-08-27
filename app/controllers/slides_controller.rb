class SlidesController < ApplicationController

  def index
    render( template: "slides/#{params[:slide]}/index" ,   layout: false )
  end

end
