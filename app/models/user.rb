class User < ActiveRecord::Base
  has_many :questions
  has_many :answers, class_name: 'Answer', foreign_key: 'creator_id'

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable

  #validates_length_of :password, :minimum => 8   
  def full_name
    first_name + " " + last_name
  end

  def role?(role)
    self.role.to_s == role.to_s
  end

  def to_s
    self.to_json
  end

end
