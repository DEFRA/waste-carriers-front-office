# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Certificates", type: :request do
  let(:user) { create(:user) }
  let(:registration) { create(:registration, :expires_soon, account_email: user.email) }

  describe "GET /fo/registrations/:reg_identifier/certificate/" do
    context "when the user who owns the registration is logged in" do
      before(:each) do
        sign_in(user)
      end

      it "responds with a PDF with a filename that includes the registration reference" do
        get "/fo/registrations/#{registration.reg_identifier}/certificate"

        expect(response.content_type).to eq("application/pdf")
        expected_content_disposition = "inline; filename=\"#{registration.reg_identifier}.pdf\"; filename*=UTF-8''#{registration.reg_identifier}.pdf"
        expect(response.headers["Content-Disposition"]).to eq(expected_content_disposition)
      end

      it "returns a 200 status code" do
        get "/fo/registrations/#{registration.reg_identifier}/certificate"
        expect(response.code).to eq("200")
      end

      context "when the 'show_as_html' query string is present" do
        context "and the value is 'true'" do
          it "responds with HTML" do
            get "/fo/registrations/#{registration.reg_identifier}/certificate?show_as_html=true"
            expect(response.content_type).to eq("text/html; charset=utf-8")
          end
        end

        [false, 1, 0, :foo].each do |bad_value|
          context "and the value is '#{bad_value}'" do
            it "responds with a PDF" do
              get "/fo/registrations/#{registration.reg_identifier}/certificate?show_as_html=#{bad_value}"
              expect(response.content_type).to eq("application/pdf")
            end
          end
        end
      end
    end

    context "when a different user is logged in" do
      before(:each) do
        sign_in(create(:user))
      end

      it "redirects to the permissions error" do
        get "/fo/registrations/#{registration.reg_identifier}/certificate"
        expect(response).to redirect_to("/fo/pages/permission")
      end
    end

    context "when no user is logged in" do
      it "redirects to the sign-in page" do
        get "/fo/registrations/#{registration.reg_identifier}/certificate"
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
