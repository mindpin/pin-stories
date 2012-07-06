# Load the rails application
require File.expand_path('../application', __FILE__)


# 添加 oAuth evernote 验证
require 'oauth'
require 'oauth/consumer'

require "thrift/types"
require "thrift/struct"
require "thrift/protocol/base_protocol"
require "thrift/protocol/binary_protocol"
require "thrift/transport/base_transport"
require "thrift/transport/http_client_transport"

$LOAD_PATH.push(Rails.root.to_s + "/lib/Evernote/EDAM")

# require "Evernote/EDAM/user_store"
# require "Evernote/EDAM/user_store_constants.rb"
# require "Evernote/EDAM/note_store"
# require "Evernote/EDAM/limits_constants.rb"

# 中文分词
require "rmmseg"
RMMSeg::Dictionary.load_dictionaries


# Initialize the rails application
Voteapp::Application.initialize!