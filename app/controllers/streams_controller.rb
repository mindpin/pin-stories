class StreamsController < ApplicationController
  before_filter :login_required
  before_filter :pre_load
  def pre_load
    @product = Product.find(params[:product_id]) if params[:product_id] 
    @stream = Stream.find(params[:id]) if params[:id]
  end
  
  def new
    @stream = @product.streams.build
  end
  
  def create
    @stream = @product.streams.build(params[:stream])
    if @stream.save
      return redirect_to "/products/#{@product.id}"
    end
    error = @stream.errors.first
    flash[:error] = "#{error[0]} #{error[1]}"
    redirect_to "/products/#{@product.id}/streams/new"
  end
  
  def show
    @stories = @stream.stories
  end
end
