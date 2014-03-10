# Load the rails application
require File.expand_path('../application', __FILE__)

ENV['lang'] = 'en'
ENV['host'] = 'apponcloud.org' # for generating url
ENV['admin_pwd'] = 'grapps888' # for enter admin UI

# Initialize the rails application
Cloud::Application.initialize!
