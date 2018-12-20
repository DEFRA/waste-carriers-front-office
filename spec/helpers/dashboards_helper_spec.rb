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

  describe "#url_for_new_registration" do
    it "returns the correct URL" do
      registration_url = "http://www.example.com/registrations/find"
      expect(helper.url_for_new_registration).to eq(registration_url)
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
    context "when the registration is lower tier" do
      before { registration.tier = "LOWER" }

      it "returns false" do
        expect(helper.display_renew_link_for?(registration)).to eq(false)
      end
    end

    context "when the registration is upper tier" do
      before { registration.tier = "UPPER" }

      context "when a renewal is possible" do
        before { allow_any_instance_of(WasteCarriersEngine::TransientRegistration).to receive(:can_be_renewed?).and_return(true) }

        it "returns true" do
          expect(helper.display_renew_link_for?(registration)).to eq(true)
        end
      end

      context "when a renewal is not possible" do
        before { allow_any_instance_of(WasteCarriersEngine::TransientRegistration).to receive(:can_be_renewed?).and_return(false) }

        it "returns false" do
          expect(helper.display_renew_link_for?(registration)).to eq(false)
        end
      end
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

  describe "#view_certificate_url" do
    it "returns the correct URL" do
      certificate_url = "http://www.example.com/registrations/#{id}/view"
      expect(helper.view_certificate_url(registration)).to eq(certificate_url)
    end
  end

  describe "#edit_url" do
    it "returns the correct URL" do
      edit_url = "http://www.example.com/registrations/#{id}/edit"
      expect(helper.edit_url(registration)).to eq(edit_url)
    end
  end

  describe "#renew_url" do
    it "returns the correct URL" do
      renew_url = "/fo/renew/#{reg_identifier}"
      expect(helper.renew_url(registration)).to eq(renew_url)
    end
  end

  describe "#order_cards_url" do
    it "returns the correct URL" do
      cards_url = "http://www.example.com/your-registration/#{id}/order/order-copy_cards"
      expect(helper.order_cards_url(registration)).to eq(cards_url)
    end
  end

  describe "#delete_url" do
    it "returns the correct URL" do
      delete_url = "http://www.example.com/registrations/#{id}/confirm_delete"
      expect(helper.delete_url(registration)).to eq(delete_url)
    end
  end
end
