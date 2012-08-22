class HttpApiParam < ActiveRecord::Base
  belongs_to :http_api

  validates :name, :desc, :presence => true
end
