class HttpApiResponse < ActiveRecord::Base
  belongs_to :http_api

  validates :code, :content, :presence => true
end
