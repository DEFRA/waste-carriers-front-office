# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  describe "#password" do
    context "when the user's password meets the requirements" do
      let(:user) { build(:user, password: "Secret123") }

      it "is valid" do
        expect(user).to be_valid
      end
    end

    context "when the user's password is blank" do
      let(:user) { build(:user, password: "") }

      it "is not valid" do
        expect(user).not_to be_valid
      end
    end

    context "when the user's password has no lowercase letters" do
      let(:user) { build(:user, password: "SECRET123") }

      it "is not valid" do
        expect(user).not_to be_valid
      end
    end

    context "when the user's password has no uppercase letters" do
      let(:user) { build(:user, password: "secret123") }

      it "is not valid" do
        expect(user).not_to be_valid
      end
    end

    context "when the user's password has no numbers" do
      let(:user) { build(:user, password: "SuperSecret") }

      it "is not valid" do
        expect(user).not_to be_valid
      end
    end

    context "when the user's password is too short" do
      let(:user) { build(:user, password: "Sec123") }

      it "is not valid" do
        expect(user).not_to be_valid
      end
    end
  end
end
