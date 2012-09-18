
%w{ models controllers helpers }.each do |dir|
  path = File.join(File.dirname(__FILE__), 'app', dir)
  $LOAD_PATH << path
  ActiveSupport::Dependencies.autoload_paths << path
  ActiveSupport::Dependencies.autoload_once_paths.delete(path)
end

ActionView::Base.send :include, MindpinUtilHelper

Rails.application.class.config.assets.paths << File.expand_path("../app/assets/stylesheets",__FILE__)

