require 'rails_helper'

describe PostsController, type: :controller do
  describe 'GET #new' do
    let(:topic) { create :topic }

    def do_request
      get :new, params: { topic_id: topic.id }
    end

    it 'renders template :new' do
      do_request
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    let(:topic) { create :topic }

    def do_request
      post :create, params: { topic_id: topic.id, post: post_params }
    end

    context 'when valid params' do
      let(:post_params) { attributes_for :post }

      it 'creates new post' do
        do_request
        expect(response).to redirect_to topic_path(assigns[:topic])
        expect(flash[:notice]).to be_present
        expect(topic.reload.posts.size).to eq 1
      end
    end

    context 'when invalid params' do
      let(:post_params) { attributes_for :post, content: nil }

      it 'renders :new with error(s)' do
        do_request
        expect(assigns[:post].errors.present?).to eq true
        expect(response).to render_template :new
        expect(topic.reload.posts.size).to eq 0
      end
    end
  end
end
