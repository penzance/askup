class Answer < ActiveRecord::Base
  belongs_to :question

  def to_s
    self.to_json
  end

end
