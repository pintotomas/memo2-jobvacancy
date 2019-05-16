require 'integration_spec_helper'

describe 'JobOffersController' do
  let(:current_user) do
    user = User.new(name: 'Joe', email: 'joe@doe.com', password: 'Aa123456')
    UserRepository.new.save(user)
    user
  end

  let(:repository) { JobOfferRepository.new }
  let!(:offer) do
    offer = JobOffer.new(title: 'a title',
                         updated_on: Date.today,
                         is_active: true,
                         user_id: current_user.id)
    repository.save(offer)
    offer
  end

  let(:signed_in_session) { { 'rack.session' => { 'current_user' => current_user.id } } }

  describe 'get :new' do
    it 'should response ok and render job_offers/new' do
      get '/job_offers/new', {}, signed_in_session
      expect(last_response).to be_ok
    end

    it 'should render job_offers/new' do
      expect_any_instance_of(JobVacancy::App).to receive(:render).with('job_offers/new')
      get '/job_offers/new', {}, signed_in_session
    end
  end

  describe 'post :create' do
    it 'should call TwitterClient when create_and_twit is present' do
      expect(TwitterClient).to receive(:publish)

      post '/job_offers/create', { job_offer: { title: 'Programmer offer' }, create_and_twit: 'create_and_twit' }, signed_in_session
      expect(last_response.location).to eq('http://example.org/job_offers/my')
    end

    it 'should not call TwitterClient when create_and_twit not present' do
      expect(TwitterClient).not_to receive(:publish)
      post '/job_offers/create', { job_offer: { title: 'Programmer offer' } }, signed_in_session
      expect(last_response.location).to eq('http://example.org/job_offers/my')
    end
  end

  describe 'put :satisfy' do
    it 'should satisfy offer' do
      id = repository.search('a title')[0].id
      put '/job_offers/satisfy/' + String(id), job_offer: { offer_id: id }
      expect(last_response.location).to eq('http://example.org/job_offers/my')
      expect(repository.search('a title')[0].satisfied?).to eq true
    end
    it 'shouldnt satisfy offer if it was satisfied' do
      id = repository.search('a title')[0].id
      put '/job_offers/satisfy/' + String(id), job_offer: { offer_id: id }
      put '/job_offers/satisfy/' + String(id), job_offer: { offer_id: id }
      expect(last_response.location).to eq('http://example.org/home/index')
    end
  end

  describe 'put :sunatisfy' do
    it 'should unsatisfy offer' do
      id = repository.search('a title')[0].id
      put '/job_offers/satisfy/' + String(id), job_offer: { offer_id: id }
      put '/job_offers/unsatisfy/' + String(id), job_offer: { offer_id: id }
      expect(last_response.location).to eq('http://example.org/job_offers/my')
      expect(repository.search('a title')[0].satisfied?).to eq false
    end
    it 'shouldnt unsatisfy offer two times' do
      id = repository.search('a title')[0].id
      put '/job_offers/unsatisfy/' + String(id), job_offer: { offer_id: id }
      put '/job_offers/unsatisfy/' + String(id), job_offer: { offer_id: id }
      expect(last_response.location).to eq('http://example.org/home/index')
    end
  end
end
