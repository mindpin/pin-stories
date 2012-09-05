class HttpApiParam < ActiveRecord::Base
  belongs_to :http_api

  validates :name, :presence => true
end
