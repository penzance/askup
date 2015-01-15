class User < ActiveRecord::Base
  has_many :questions
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, recoverable, and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable

  def full_name
    first_name + " " + last_name
  end
end
