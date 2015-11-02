class Question < ActiveRecord::Base
  acts_as_voteable
  belongs_to :user
  belongs_to :qset
  has_many :answers, :dependent => :destroy
  accepts_nested_attributes_for :answers, allow_destroy: true

  def belongs_to?(user)
    user and self.user_id == user.id
  end

  def to_s
    self.to_json(:include => :answers)
  end
end