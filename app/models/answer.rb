class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: :true

  def mark_as_best
    transaction do
      self.question.answers.update_all(best_answer: false)
      self.update(best_answer: true)
    end
  end
end
