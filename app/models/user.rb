# -*- encoding : utf-8 -*-

require Rails.root.join(*%w(lib active_model))

class User
  include Mongoid::Document
  include Mongoid::Validations

  field :uid,        type: String
  field :provider,   type: String
  field :login,      type: String
  field :email,      type: String
  field :name,       type: String
  field :avatar_url, type: String
  field :token,      type: String

  has_many :votes, dependent: :destroy do
    def current
      where(created_on: Time.zone.now.to_date).first
    end
  end

  # validates_membership_in :wimdu, on: :create

  def self.find_or_create_with_omniauth(auth)
    find_or_create_by(provider: auth['provider'], uid: auth['uid']) do |u|
      u.login      = auth['info']['nickname']
      u.email      = auth['info']['email']
      u.name       = auth['info']['name']
      u.avatar_url = auth['info']['image']
      u.token      = auth['credentials']['token']
    end
  end

  def choice_for_today
    votes.current.try(:place)
  end

  def vote_for!(place)
    vote = self.votes.current || self.votes.build
    vote.place = place

    vote.save
  end
end