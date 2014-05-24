class Private::PicturesController < AuthenticatedController
  def index
    @pictures = current_user.pictures

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json:{ files: @pictures.collect { |p| p.to_jq_upload } } }
      format.xml { render xml: @pictures }
    end
  end


  def new
    @picture = Picture.new(:user => current_user)
  end

  def create
    @picture = current_user.pictures.build(post_params)

    respond_to do |format|
      if @picture.save!
        format.html {
          render :json => {files: [@picture.to_jq_upload] }.to_json,
          :content_type => 'text/html',
          :layout => false
        }
        format.json { render json: { files: [ @picture.to_jq_upload ]}.to_json, status: :created, location: [:private, @picture] }
      else
        format.html { render action: "new" }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @picture = current_user.pictures.find(params[:id])
    @picture.destroy
    render :json => true
  end

  private

  def post_params
    params[:picture][:image] = params[:picture][:image].first if params[:picture] and params[:picture][:image].is_a?(Array)
    params.fetch(:picture).permit(:image)
  end


end
