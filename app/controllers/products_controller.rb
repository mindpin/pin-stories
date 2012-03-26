class ProductsController < ApplicationController
  before_filter :login_required
  before_filter :pre_load
  def pre_load
    @product = Product.find(params[:id]) if params[:id]
  end
  
  def index
    @products = Product.all
  end
  
  def new
    @product = Product.new
  end
  
  def create
    @product = Product.new(params[:product])
    if @product.save
      return redirect_to "/products"
    end
    error = @product.errors.first
    flash[:error] = "#{error[0]} #{error[1]}"
    redirect_to "/products/new"
  end
  
  def show
    @streams = @product.streams
  end
end
