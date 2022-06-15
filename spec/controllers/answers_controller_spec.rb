require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  before { login(user) }

  describe 'GET #new' do
    before { get :new, params: { question_id: question.id} }

    it 'assigns a Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer) } }.to change(Answer, :count).by(1)
      end

      it 'redirects to show question view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer) }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save an answer' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) } }.to_not change(Answer, :count)
      end
      
      it 'redirects to show question view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) }
        expect(response).to redirect_to question_path(question)
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    let!(:answer) { create(:answer, user: user, question: question) }

    it 'deletes the answer' do
      expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
    end
    
    it 'redirects to show question' do
      delete :destroy, params: { id: answer }
      expect(response).to redirect_to question_path(question)
    end
  end
end
