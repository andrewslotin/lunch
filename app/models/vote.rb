# -*- encoding : utf-8 -*-

class Vote
  include Mongoid::Document

  field :created_on, type: Date, default: -> { Time.zone.now.to_date }

  belongs_to :user
  belongs_to :place

  validates :user, uniqueness: { scope: :created_on }

  scope :today, where(created_on: Time.zone.now)

  index created_on: 1
end