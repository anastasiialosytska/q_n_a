class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:new, :create]
  before_action :set_answer, only: :destroy

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params.merge(user_id: current_user.id))
    
    @answer.save ? flash[:notice] = 'Your answer successfully added' : flash[:alert] = "Body can't be blank"
    redirect_to @question
  end

  def destroy
    if current_user.id == @answer.user_id
      @answer.destroy
      redirect_to question_path(@answer.question), notice: 'Answer successfully deleted'
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
