# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Root", type: :request do
  describe "GET /" do
    it "renders the dashboards index template" do
      get "/"
      expect(response).to redirect_to(fo_path)
    end

    it "returns a 200 response" do
      get "/"
      expect(response).to have_http_status(302)
    end
  end

  describe "GET /fo/renew/[registration number]" do
    context "when the user is not signed in" do
      let(:registration) { create(:registration, reg_identifier: "CBDU12345") }
      it "returns a 200 response" do
        get "/fo/renew/CBDU12345"
        expect(response).to have_http_status(302)
      end

      it "redirects the user to the sign in page" do
        get "/fo/renew/CBDU12345"
        expect(response).to redirect_to(new_user_session_path)
      end

      it "redirects the user to the renewal start page after sign in" do
        user = create(:user)
        reg_identifier = create(:registration, :expires_soon, account_email: user.email).reg_identifier
        renew_path = "/fo/renew/#{reg_identifier}"

        get renew_path
        post "/fo/users/sign_in", user: { "email": user.email, "password": "Secret123" }
        expect(response).to redirect_to(renew_path)
      end
    end

    context "when the user is signed in" do
      let(:user) { create(:user) }
      # We have to force invocation of creating the registration because we
      # don't directly reference it in our test, which means it doesn't get
      # created and the test fails.
      let!(:registration) { create(:registration, :expires_soon, account_email: user.email) }

      before(:each) do
        sign_in(user)
      end

      it "returns a 200 response" do
        get "/fo/renew/#{registration.reg_identifier}"
        expect(response).to have_http_status(200)
      end

      it "redirects the user to the renewal start page" do
        get "/fo/renew/#{registration.reg_identifier}"
        expect(response.body).to include("You are about to renew your registration")
      end
    end
  end
end
