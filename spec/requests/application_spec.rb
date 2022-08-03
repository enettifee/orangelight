# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController, type: :request do
  let(:user) { FactoryBot.create(:valid_princeton_patron) }
  describe "#after_sign_in_path_for" do
    context "as a logged in user" do
      before { login_as(user) }

      context 'url only' do
        it 'redirects to alma' do
          get "/users/sign_in?origin=%2Fredirect-to-alma"
          expect(response).to redirect_to("/redirect-to-alma")
        end
      end
      context 'only an origin is set' do
        it 'redirects to alma' do
          params = { origin: '/redirect-to-alma' }
          get '/users/sign_in', params: params
          expect(response).to redirect_to("/redirect-to-alma")
        end
        it 'redirects to bookmarks' do
          params = { origin: '/bookmarks' }
          get '/users/sign_in', params: params
          expect(response).to redirect_to('/bookmarks')
        end
      end

      context 'only a referrer is set' do
        it 'redirects to the referrer' do
          headers = { 'HTTP_REFERER' => '/bookmarks' }
          get '/users/sign_in', headers: headers
          expect(response).to redirect_to('/bookmarks')
        end
        it 'redirects to the origin from the referrer' do
          headers = { 'HTTP_REFERER' => '/users/sign_in/?origin=%2Fbookmarks' }
          get '/users/sign_in', headers: headers
          expect(response).to redirect_to('/bookmarks')
        end
      end

      context 'both an origin and a referrer are set' do
        it 'redirects to alma' do
          params = { origin: '/redirect-to-alma' }
          headers = { 'HTTP_REFERER' => '/' }
          get '/users/sign_in', params: params, headers: headers
          expect(response).to redirect_to('/redirect-to-alma')
        end
      end

      context "with omniauth origin" do
        before do
          OmniAuth.config.test_mode = true
          Rails.application.env_config["omniauth.origin"] = '/bookmarks'
        end

        it "sends the user back to the omniauth origin" do
          get '/users/sign_in/'
          expect(response).to redirect_to('/bookmarks')
        end
      end
    end

    context "as an unauthenticated user" do
      it 'does not redirect the user' do
        get "/users/sign_in?origin=%2Fredirect-to-alma"
        expect(response).to be_successful
      end
    end
  end
end
