# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sessions", type: :request do
  describe "GET /fo/users/sign_in" do
    context "when a user is not signed in" do
      it "returns a success response" do
        get new_user_session_path
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "POST /fo/users/sign_in" do
    context "when a user is not signed in" do
      context "when valid user details are submitted" do
        let(:user) { create(:user) }

        it "signs the user in" do
          post user_session_path, params: { user: { email: user.email, password: user.password } }
          expect(controller.current_user).to eq(user)
        end

        it "returns a 302 response" do
          post user_session_path, params: { user: { email: user.email, password: user.password } }
          expect(response).to have_http_status(302)
        end

        it "redirects to /fo" do
          post user_session_path, params: { user: { email: user.email, password: user.password } }
          expect(response).to redirect_to(fo_path)
        end
      end
    end
  end

  describe "DELETE /fo/users/sign_out" do
    context "when the user is signed in" do
      let(:user) { create(:user) }

      before(:each) do
        sign_in(user)
      end

      it "signs the user out" do
        get destroy_user_session_path
        expect(controller.current_user).to be_nil
      end

      it "returns a 302 response" do
        get destroy_user_session_path
        expect(response).to have_http_status(302)
      end

      it "redirects to the user sign in page" do
        get destroy_user_session_path
        expect(response).to redirect_to(new_user_session_path)
      end

      it "updates the session_token" do
        old_session_token = user.session_token
        get destroy_user_session_path
        expect(user.reload.session_token).to_not eq(old_session_token)
      end
    end
  end
end
