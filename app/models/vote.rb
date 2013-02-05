# -*- encoding : utf-8 -*-

class Vote
  include Mongoid::Document

  field :good, type: Boolean
  field :created_on, type: Date, default: -> { Time.zone.now.to_date }

  belongs_to :user
  belongs_to :place

  validates :user, uniqueness: { scope: :created_on }

  scope :today, where(created_on: Time.zone.now)
  scope :yesterday, where(created_on: Time.zone.now - 1.day)
  scope :old, lt(created_on: Time.zone.now)
  scope :unrated, yesterday.where(good: nil)

  index created_on: 1

  def like!
    self.update_attribute :good, true
  end

  def dislike!
    self.update_attribute :good, false
  end
end