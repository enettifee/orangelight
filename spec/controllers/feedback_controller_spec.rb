# frozen_string_literal: true
require "rails_helper"

RSpec.describe FeedbackController, type: :controller do
  describe "#ask_a_question" do
    it "routes to the Ask A Question form" do
      get :ask_a_question, params: { ask_a_question_form: { id: '123', title: 'My cool title' } }

      expect(response).to be_successful
    end
  end
end