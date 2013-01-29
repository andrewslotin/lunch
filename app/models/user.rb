# -*- encoding : utf-8 -*-

class User
  include Mongoid::Document

  field :uid,        type: String
  field :provider,   type: String
  field :login,      type: String
  field :email,      type: String
  field :name,       type: String
  field :avatar_url, type: String
  field :token,      type: String

  validate :wimduer?, on: :create

  def self.find_or_create_with_omniauth(auth)
    find_or_create_by(provider: auth['provider'], uid: auth['uid']) do |u|
      u.login      = auth['info']['nickname']
      u.email      = auth['info']['email']
      u.name       = auth['info']['name']
      u.avatar_url = auth['info']['image']
      u.token      = auth['credentials']['token']
    end
  end

  def wimduer?
    github.organizations.any? { |org| org.login == "wimdu" }
  end

  private

  def github
    Octokit::Client.new(login: login, oauth_token: token)
  end
end