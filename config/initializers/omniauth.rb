# -*- encoding : utf-8 -*-

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV['GITHUB_CLIENT_ID'], ENV['GITHUB_CLIENT_SECRET']
end