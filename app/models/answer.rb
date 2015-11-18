class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'

  def to_s
    self.to_json
  end

end
