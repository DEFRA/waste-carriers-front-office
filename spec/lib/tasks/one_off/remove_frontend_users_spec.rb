# frozen_string_literal: true

require "rails_helper"

RSpec.describe "RemoveFrontendUsers", type: :rake do
  let(:task) { Rake::Task["one_off:remove_frontend_users"] }

  include_context "rake"

  before do
    task.reenable
  end

  it "runs without error" do
    expect { task.invoke }.not_to raise_error
  end

  context "when front-end user accounts are present" do
    before do
      create_list(:user, 3)
    end

    it "removes all front-end user accounts" do
      expect(User.count).not_to be_zero
      task.invoke
      expect(User.count).to be_zero
    end
  end
end
