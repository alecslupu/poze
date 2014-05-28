class PicturesController < ApplicationController

  def newest
    @pictures = Picture.recent.page( Integer(params[:page] || 1) ).per(12)

    respond_to do |format|
      format.html { render :template => 'pictures/index' }
    end
  end


  def show
    @picture = Picture.friendly.find(params[:id])
  end
end
