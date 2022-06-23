require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  before { login(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer), format: :js } }.to change(Answer, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save an answer' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid), format: :js } }.to_not change(Answer, :count)
      end
      
      it 'renders create template' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    let!(:answer) { create(:answer, user: user, question: question) }

    it 'deletes the answer' do
      expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
    end
    
    it 'redirects to show question' do
      delete :destroy, params: { id: answer }, format: :js
      expect(response).to render_template :destroy
    end
  end

  describe 'GET #update_to_best_answer' do
    before { login(user) }

    let!(:answer) { create(:answer, user: user, question: question) }
    let!(:current_best_answer) { create(:answer, user: user, question: question, best_answer: true) }

    it 'mark the answer as best' do
      get :update_to_best_answer, params: { id: answer }, format: :js, xhr: true
      answer.reload
      current_best_answer.reload
      expect(answer.best_answer).to eq true
      expect(current_best_answer.best_answer).to eq false
    end

    it 'renders update_to_best_answer view' do
      get :update_to_best_answer, params: { id: answer }, format: :js, xhr: true
      expect(response).to render_template :update_to_best_answer
    end
  end
end
