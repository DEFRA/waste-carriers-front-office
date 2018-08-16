# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Dashboards", type: :request do
  describe "/fo" do
    context "when a valid user is signed in" do
      let(:user) { create(:user) }
      before(:each) do
        sign_in(user)
      end

      it "redirects to the frontend user dashboard" do
        get "/fo"
        expect(response.body).to include(Rails.configuration.wcrs_frontend_url)
      end

      it "returns a 302 response" do
        get "/fo"
        expect(response).to have_http_status(302)
      end
    end

    context "when a user is not signed in" do
      it "redirects to the sign-in page" do
        get "/fo"
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
