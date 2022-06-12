require 'rails_helper'

describe TopicsController, type: :controller do
  describe 'GET #index' do
    def do_request
      get :index
    end

    context 'when topics are available' do
      before do
        FactoryBot.create_list(:topic, 25)
      end

      it 'returns list of topics' do
        do_request
        expect(assigns[:topics].size).to eq 20
      end
    end

    context 'when no topics found' do
      it 'returns empty array' do
        do_request
        expect(assigns[:topics].count).to eq 0
      end
    end
  end

  describe 'GET #new' do
    def do_request
      get :new
    end

    it 'renders template :new' do
      do_request
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    def do_request
      post :create, params: { topic: topic_params }
    end

    context 'when valid params' do
      let(:topic_params) { attributes_for :topic }

      it 'creates topic successfully' do
        expect { do_request }.to change(Topic, :count).from(0).to(1)
        expect(response).to redirect_to topic_path(assigns[:topic])
        expect(flash[:notice]).to be_present
      end
    end

    context 'when invalid params' do
      let(:topic_params) { attributes_for :topic, title: nil }

      it 'renders :new with error(s)' do
        expect { do_request }.not_to change(Topic, :count)
        expect(assigns[:topic].errors.present?).to eq true
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #show' do
    def do_request(params = {})
      get :show, params: params
    end

    context 'when topic is valid' do
      let(:topic) { create :topic, title: 'Happy coding!' }

      it 'renders template :show' do
        do_request(id: topic.id)
        expect(response).to render_template :show
        expect(assigns[:topic].title).to eq 'Happy coding!'
        expect(assigns[:posts].size).to eq 0
      end
    end

    context 'when topic is invalid' do
      it 'raises error' do
        expect { do_request(id: 0) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'GET #search' do
    def do_request(params = {})
      get :search, params: params
    end

    context 'when matchs the topic title' do
      before do
        FactoryBot.create(:topic, title: 'How to make a DDOS attack')
        FactoryBot.create(:topic, title: 'How to install RVM')
        Topic.__elasticsearch__.refresh_index!
      end

      it 'returns matched topics' do
        do_request(search: { keyword: 'how to' })
        expect(response).to render_template :index
        expect(assigns[:topics].records.to_a.count).to eq 2
      end
    end

    context 'when no topics matched' do
      it 'returns empty' do
        do_request(search: { keyword: 'ruby' })
        expect(response).to render_template :index
        expect(assigns[:topics].records.to_a.count).to eq 0
      end
    end
  end
end
