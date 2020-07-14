# frozen_string_literal: true

require "rails_helper"

RSpec.describe DashboardsHelper, type: :helper do
  let(:registration) { create(:registration) }
  let(:reg_identifier) { registration.reg_identifier }
  let(:id) { registration["_id"] }

  before do
    allow(Rails.configuration).to receive(:wcrs_frontend_url).and_return("http://www.example.com")
  end

  describe "#url_to_change_password" do
    it "returns the correct URL" do
      password_url = "/fo/users/edit-password"
      expect(helper.url_to_change_password).to eq(password_url)
    end
  end

  describe "#url_for_new_registration" do
    before(:each) do
      allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:new_registration) { feature_enabled }
    end

    context "when the 'new_registration' feature is enabled" do
      let(:feature_enabled) { true }

      it "returns the correct URL" do
        registration_url = "/fo/start"
        expect(helper.url_for_new_registration).to eq(registration_url)
      end
    end

    context "when the 'new_registration' feature is not enabled" do
      let(:feature_enabled) { false }

      it "returns the correct URL" do
        registration_url = "http://www.example.com/registrations/start"
        expect(helper.url_for_new_registration).to eq(registration_url)
      end
    end
  end

  describe "#display_view_certificate_link_for?" do
    context "when the registration is active" do
      before { registration.metaData.status = "ACTIVE" }

      it "returns true" do
        expect(helper.display_view_certificate_link_for?(registration)).to eq(true)
      end
    end

    context "when the registration is not active" do
      before { registration.metaData.status = "PENDING" }

      it "returns false" do
        expect(helper.display_view_certificate_link_for?(registration)).to eq(false)
      end
    end
  end

  describe "#display_renew_link_for?" do
    context "when the registration is lower tier" do
      before { registration.tier = "LOWER" }

      it "returns false" do
        expect(helper.display_renew_link_for?(registration)).to eq(false)
      end
    end

    context "when the registration is upper tier" do
      before { registration.tier = "UPPER" }

      context "when a renewal is possible" do
        before { allow_any_instance_of(WasteCarriersEngine::RenewingRegistration).to receive(:can_be_renewed?).and_return(true) }

        it "returns true" do
          expect(helper.display_renew_link_for?(registration)).to eq(true)
        end
      end

      context "when a renewal is not possible" do
        before { allow_any_instance_of(WasteCarriersEngine::RenewingRegistration).to receive(:can_be_renewed?).and_return(false) }

        it "returns false" do
          expect(helper.display_renew_link_for?(registration)).to eq(false)
        end
      end
    end
  end

  describe "#display_no_action_links?" do
    context "when at least one action link should be displayed" do
      before { allow(helper).to receive(:display_renew_link_for?).and_return(true) }

      it "returns false" do
        expect(helper.display_no_action_links?(registration)).to eq(false)
      end
    end

    context "when no action links should be displayed" do
      before do
        allow(helper).to receive(:display_view_certificate_link_for?).and_return(false)
        allow(helper).to receive(:display_renew_link_for?).and_return(false)
      end

      it "returns true" do
        expect(helper.display_no_action_links?(registration)).to eq(true)
      end
    end
  end

  describe "#view_certificate_url" do
    it "returns the correct URL" do
      certificate_url = "/fo/registrations/#{reg_identifier}/certificate"
      expect(helper.view_certificate_url(registration)).to eq(certificate_url)
    end
  end

  describe "#renew_url" do
    it "returns the correct URL" do
      renew_url = "/fo/#{reg_identifier}/renew"
      expect(helper.renew_url(registration)).to eq(renew_url)
    end
  end
end
