class HttpApiParam < ActiveRecord::Base
  belongs_to :http_api

  validates :http_api_id, :name, :need, :desc, :presence => true
end
