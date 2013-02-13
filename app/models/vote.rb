# -*- encoding : utf-8 -*-

class Vote
  include Mongoid::Document

  field :vote, type: Integer
  field :created_on, type: Date, default: -> { Time.zone.now.to_date }

  belongs_to :user
  belongs_to :place

  validates :user, uniqueness: { scope: :created_on }
  validates :vote, inclusion: { in: [-1, 1, nil]}

  scope :today, where(created_on: Time.zone.now)
  scope :yesterday, where(created_on: Time.zone.now - 1.day)
  scope :old, lt(created_on: Time.zone.now)
  scope :unrated, yesterday.where(vote: nil)

  index created_on: 1

  def like!
    self.update_attribute :vote, 1
  end

  def dislike!
    self.update_attribute :vote, -1
  end

  def good?
    self.vote > 0
  end

  def bad?
    self.vote < 0
  end
end