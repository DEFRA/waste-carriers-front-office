# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sessions" do

  before { allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:block_front_end_logins).and_return false }

  describe "GET /fo/users/sign_in" do

    context "when a user is not signed in" do
      it "returns a success response" do
        get new_user_session_path
        expect(response).to have_http_status(:ok)
      end
    end

    context "when the :block_front_end_logins feature toggle is active" do
      before { allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:block_front_end_logins).and_return true }

      it "redirects to the application root" do
        get new_user_session_path
        expect(response).to redirect_to(root_path)
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
          expect(response).to have_http_status(:found)
        end

        it "redirects to /fo" do
          post user_session_path, params: { user: { email: user.email, password: user.password } }
          expect(response).to redirect_to(fo_path)
        end
      end

      context "when the :block_front_end_logins feature toggle is active" do
        let(:user) { create(:user) }

        before { allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:block_front_end_logins).and_return true }

        it "redirects to the application root" do
          post user_session_path, params: { user: { email: user.email, password: user.password } }
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end

  describe "DELETE /fo/users/sign_out" do
    context "when the user is signed in" do
      let(:user) { create(:user) }

      before { sign_in(user) }

      it "signs the user out" do
        get destroy_user_session_path
        expect(controller.current_user).to be_nil
      end

      it "returns a 302 response" do
        get destroy_user_session_path
        expect(response).to have_http_status(:found)
      end

      it "redirects to the user sign in page" do
        get destroy_user_session_path
        expect(response).to redirect_to(new_user_session_path)
      end

      it "updates the session_token" do
        old_session_token = user.session_token
        get destroy_user_session_path
        expect(user.reload.session_token).not_to eq(old_session_token)
      end
    end
  end
end
