# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Passwords", type: :request do
  describe "GET /fo/users/edit-password" do
    context "when the user is not signed in" do
      it "redirects the user to the sign in page" do
        get "/fo/users/edit-password"
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when the user is signed in" do
      let(:user) { create(:user) }

      before(:each) do
        sign_in(user)
      end

      it "loads the change password page" do
        get "/fo/users/edit-password"

        expect(response).to have_http_status(200)
        expect(response).to render_template("passwords/edit")
        expect(response.body).to include("Change your password")
      end
    end
  end

  describe "PATCH /fo/users/edit-password" do
    let(:user) { create(:user) }

    context "when the user is not signed in" do
      it "redirects the user to the sign in page" do
        patch "/fo/users/edit-password"
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when the user is signed in" do
      before(:each) do
        sign_in(user)
      end

      context "when valid params are submitted" do
        let(:params) do
          {
            user:
            {
              current_password: user.password,
              password: "AcceptablePassword123",
              confirm_password: "AcceptablePassword123"
            }
          }
        end

        it "updates the password and redirects to the /fo" do
          old_password = user.password

          patch "/fo/users/edit-password", params: params

          expect(user.reload.password).to_not eq(old_password)
          expect(response).to have_http_status(302)
          expect(response).to redirect_to(fo_path)
        end
      end

      context "when invalid params are submitted" do
        let(:params) do
          {
            user:
            {
              current_password: user.password,
              password: "foo",
              confirm_password: "bar"
            }
          }
        end

        it "does not update the password and redirects to the edit page" do
          old_password = user.encrypted_password

          patch "/fo/users/edit-password", params: params

          expect(user.reload.encrypted_password).to eq(old_password)
          expect(response).to have_http_status(200)
          expect(response).to render_template("passwords/edit")
        end
      end
    end
  end
end
