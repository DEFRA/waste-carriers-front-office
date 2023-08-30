# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Dashboards" do
  describe "/fo" do

    before do
      allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).and_call_original
      allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:block_front_end_logins).and_return false
    end

    context "when a valid user is signed in" do
      let(:user) { create(:user) }

      before { sign_in(user) }

      it "renders the index template" do
        get "/fo"
        expect(response).to render_template(:index)
      end

      it "returns a 200 response" do
        get "/fo"
        expect(response).to have_http_status(:ok)
      end

      it "lists registrations which belong to the user" do
        reg_identifier = create(:registration, account_email: user.email).reg_identifier

        get "/fo"
        expect(response.body).to include(reg_identifier)
      end

      it "does not list registrations which don't belong to the user" do
        reg_identifier = create(:registration, account_email: "foo@example.com").reg_identifier

        get "/fo"
        expect(response.body).not_to include(reg_identifier)
      end

      it "does not list registrations which are inactive" do
        registration = create(:registration)
        registration.metaData.status = "INACTIVE"
        reg_identifier = registration.reg_identifier

        get "/fo"
        expect(response.body).not_to include(reg_identifier)
      end

      context "when the user has no registrations" do
        it "says there are no results" do
          get "/fo"
          expect(response.body).to include("No results")
        end
      end
    end

    context "when a user is not signed in" do
      it "redirects to the sign-in page" do
        get "/fo"
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  context "when the :block_front_end_logins feature toggle is active" do
    before { allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:block_front_end_logins).and_return true }

    it "redirects to the application root" do
      get "/fo"
      expect(response).to redirect_to(root_path)
    end
  end
end
