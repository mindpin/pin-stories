class LemmasController < ApplicationController
  def new
    @product = Product.find(params[:product_id])
    @lemma = Lemma.new
  end

  def create
    product = Product.find(params[:product_id])
    
    lemma = Lemma.new params[:lemma]
    lemma.product = product

    if lemma.save
      return redirect_to [product, :lemmas]
    end

    flash[:error] = lemma.errors.to_json
    redirect_to [:new, product, :lemma]
  end
end