require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

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
        expect(response).to render_template('questions/show')
      end
    end

    context 'with invalid attributes' do
      it 'does not save an answer' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) } }.to_not change(Answer, :count)
      end
      
      it 'redirects to show question view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template('questions/show')
      end
    end
  end
end
