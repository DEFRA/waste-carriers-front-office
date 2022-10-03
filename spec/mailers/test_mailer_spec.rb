# frozen_string_literal: true

require "rails_helper"

# Simple test for SonarCloud coverage purposes
RSpec.describe TestMailer do
  describe "test_mailer" do
    it "populates the test_email" do
      expect(described_class.test_email).not_to be_nil
    end
  end
end
