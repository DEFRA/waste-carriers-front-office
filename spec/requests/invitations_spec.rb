# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Invitations", type: :request do
  let(:token) do
    email = attributes_for(:user)[:email]
    User.invite!(email: email, skip_invitation: true).raw_invitation_token
  end

  describe "GET /fo/users/invitation/accept" do
    context "when there is a valid invitation token" do
      it "returns a success response" do
        get accept_user_invitation_path, invitation_token: token
        expect(response).to have_http_status(200)
      end
    end

    context "when there is an invalid invitation token" do
      it "redirects to the sign in page" do
        get accept_user_invitation_path, invitation_token: "foo"
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when there is no invitation token" do
      it "redirects to the sign in page" do
        get accept_user_invitation_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PUT /fo/users/invitation/accept" do
    let(:params) do
      {
        invitation_token: token,
        password: "Secret123",
        password_confirmation: "Secret123"
      }
    end

    context "when params are valid" do
      it "redirects to the fo_path" do
        put user_invitation_path, user: params
        expect(response).to redirect_to(fo_path)
      end
    end

    context "when params are invalid" do
      it "renders the invitation accept page again" do
        put user_invitation_path, user: "foo"
        expect(response).to render_template(:edit)
      end
    end
  end
end
