# frozen_string_literal: true

require "rails_helper"

RSpec.describe DashboardsHelper, type: :helper do
  let(:registration) { create(:registration) }
  let(:reg_identifier) { registration.reg_identifier }

  describe "#url_to_view_certificate_for" do
    it "returns a temp value" do
      expect(helper.url_to_view_certificate_for(registration)).to eq("#")
    end
  end

  describe "#url_to_edit" do
    it "returns a temp value" do
      expect(helper.url_to_edit(registration)).to eq("#")
    end
  end

  describe "#url_to_renew" do
    it "returns the correct URL" do
      renew_url = "/fo/renew/#{reg_identifier}"
      expect(helper.url_to_renew(registration)).to eq(renew_url)
    end
  end

  describe "#url_to_order_cards_for" do
    it "returns a temp value" do
      expect(helper.url_to_order_cards_for(registration)).to eq("#")
    end
  end

  describe "#url_to_delete" do
    it "returns a temp value" do
      expect(helper.url_to_delete(registration)).to eq("#")
    end
  end
end
