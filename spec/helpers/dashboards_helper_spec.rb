# frozen_string_literal: true

require "rails_helper"

RSpec.describe DashboardsHelper, type: :helper do
  let(:registration) { create(:registration) }
  let(:reg_identifier) { registration.reg_identifier }
  let(:id) { registration["_id"] }

  before do
    allow(Rails.configuration).to receive(:wcrs_frontend_url).and_return("http://www.example.com")
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
