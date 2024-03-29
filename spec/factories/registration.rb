# frozen_string_literal: true

# - refactoring code as suggested by rubocop makes entire test suita to fail for no particular reason
FactoryBot.define do
  factory :registration, class: "WasteCarriersEngine::Registration" do
    sequence :reg_identifier do |n|
      "CBDU#{n}"
    end

    tier { "UPPER" }

    addresses { [build(:address), build(:address)] }

    metaData { association(:metaData, strategy: :build) }

    trait :expires_soon do
      metaData { association(:metaData, status: :ACTIVE, strategy: :build) }
      expires_on { 2.months.from_now }
    end
  end
end
