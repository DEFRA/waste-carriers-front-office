# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Root" do
  describe "GET /" do
    it "returns a 200 and loads /fo/start" do
      get "/"

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Is this a new registration?")
    end
  end

  describe "GET /fo/renew/[registration number]" do
    let(:user) { create(:user) }
    let(:registration) { create(:registration, :expires_soon, account_email: user.email) }

    before do
      allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).and_call_original
    end

    it "redirects to the application root page" do
      get "/fo/#{registration.reg_identifier}/renew"
      expect(response).to redirect_to("/")
    end
  end
end
