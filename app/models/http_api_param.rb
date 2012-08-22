class HttpApiParam < ActiveRecord::Base
  belongs_to :http_api

  validates :name, :need, :desc, :presence => true
end
