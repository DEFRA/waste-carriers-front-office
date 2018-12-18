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
      password_url = "http://www.example.com/users/edit"
      expect(helper.url_to_change_password).to eq(password_url)
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

  describe "#display_edit_link_for?" do
    context "when the registration is active" do
      before { registration.metaData.status = "ACTIVE" }

      it "returns true" do
        expect(helper.display_edit_link_for?(registration)).to eq(true)
      end
    end

    context "when the registration is pending" do
      before { registration.metaData.status = "PENDING" }

      it "returns true" do
        expect(helper.display_edit_link_for?(registration)).to eq(true)
      end
    end

    context "when the registration is not active or pending" do
      before { registration.metaData.status = "REVOKED" }

      it "returns false" do
        expect(helper.display_edit_link_for?(registration)).to eq(false)
      end
    end
  end

  describe "#display_renew_link_for?" do
    it "returns the correct value" do
      expect(helper.display_renew_link_for?(registration)).to eq(true)
    end
  end

  describe "#display_order_cards_link_for?" do
    context "when the registration is upper tier" do
      before { registration.tier = "UPPER" }

      context "when the registration is active" do
        before { registration.metaData.status = "ACTIVE" }

        it "returns true" do
          expect(helper.display_order_cards_link_for?(registration)).to eq(true)
        end
      end

      context "when the registration is pending" do
        before { registration.metaData.status = "PENDING" }

        it "returns true" do
          expect(helper.display_order_cards_link_for?(registration)).to eq(true)
        end
      end

      context "when the registration is not active or pending" do
        before { registration.metaData.status = "REVOKED" }

        it "returns false" do
          expect(helper.display_order_cards_link_for?(registration)).to eq(false)
        end
      end
    end

    context "when the registration is lower tier" do
      before { registration.tier = "LOWER" }

      it "returns false" do
        expect(helper.display_order_cards_link_for?(registration)).to eq(false)
      end
    end
  end

  describe "#display_delete_link_for?" do
    context "when the registration is active" do
      before { registration.metaData.status = "ACTIVE" }

      it "returns true" do
        expect(helper.display_delete_link_for?(registration)).to eq(true)
      end
    end

    context "when the registration is not active" do
      before { registration.metaData.status = "PENDING" }

      it "returns false" do
        expect(helper.display_delete_link_for?(registration)).to eq(false)
      end
    end
  end

  describe "#url_to_view_certificate_for" do
    it "returns the correct URL" do
      certificate_url = "http://www.example.com/registrations/#{id}/view"
      expect(helper.url_to_view_certificate_for(registration)).to eq(certificate_url)
    end
  end

  describe "#url_to_edit" do
    it "returns the correct URL" do
      edit_url = "http://www.example.com/registrations/#{id}/edit"
      expect(helper.url_to_edit(registration)).to eq(edit_url)
    end
  end

  describe "#url_to_renew" do
    it "returns the correct URL" do
      renew_url = "/fo/renew/#{reg_identifier}"
      expect(helper.url_to_renew(registration)).to eq(renew_url)
    end
  end

  describe "#url_to_order_cards_for" do
    it "returns the correct URL" do
      cards_url = "http://www.example.com/your-registration/#{id}/order/order-copy_cards"
      expect(helper.url_to_order_cards_for(registration)).to eq(cards_url)
    end
  end

  describe "#url_to_delete" do
    it "returns the correct URL" do
      delete_url = "http://www.example.com/registrations/#{id}/confirm_delete"
      expect(helper.url_to_delete(registration)).to eq(delete_url)
    end
  end
end
