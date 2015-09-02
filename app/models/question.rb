class Question < ActiveRecord::Base
  belongs_to :user
  belongs_to :qset
  has_many :answers, :dependent => :destroy
  accepts_nested_attributes_for :answers, allow_destroy: true

  def to_s
    self.to_json(:include => :answers)
  end
end