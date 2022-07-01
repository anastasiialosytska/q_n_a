class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: :create
  before_action :set_answer, only: [:update, :destroy, :update_to_best_answer, :delete_attachment]
  before_action :get_list_of_answers, only: [:update, :update_to_best_answer, :delete_attachment]

  def create
    @answer = @question.answers.create(answer_params.merge(user_id: current_user.id))
  end

  def update
    @answer.update(answer_params)
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
  end

  def update_to_best_answer
    @answer.mark_as_best if current_user.author_of?(@answer.question)
  end

  def delete_attachment
    if current_user.author_of?(@answer)
      @answer.files.where(id: params[:file_id]).purge
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end

  def get_list_of_answers
    set_answer
    @answers = Answer.where(question_id: @answer.question_id).order(best_answer: :desc, created_at: :asc)
  end
end
