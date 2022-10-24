# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Dashfoards" do
  describe "/fo" do
    context "when a valid user is signed in" do
      let(:user) { create(:user) }

      before do
        sign_in(user)
      end

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
end
