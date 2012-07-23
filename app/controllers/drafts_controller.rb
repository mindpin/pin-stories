class DraftsController < ApplicationController
  def index
    @drafts = current_user.drafts.paginate :page => params[:page], 
                                           :per_page => 20
  end

  def show
    # 打开草稿，并重定向
    draft = Draft.find(params[:id])
    hash = draft.load_hash

    case draft.model_type
    when 'Story'
      product_id = hash[:product_id]
      story_id = draft.model_id

      return redirect_to "/products/#{product_id}/stories/new?draft_temp_id=#{draft.temp_id}" if story_id.blank?
      # return redirect_to "/stories/#{story_id}/edit?temp_id=#{draft.temp_id}"

    when 'WikiPage'
      # product_id = hash[:product_id]
      # title      = hash[:title]
      # wiki_page_id = draft.model_id

      # return redirect_to "/products/#{product_id}/wiki_new?temp_id=#{draft.temp_id}" if wiki_page_id.blank?
      # return redirect_to "/products/#{product_id}/wiki/#{drafted_hash[:title]}/edit?temp_id=#{draft.temp_id}"
    end

    flash[:error] = '无法打开指定草稿'
    redirect_to '/drafts'
  end
end
