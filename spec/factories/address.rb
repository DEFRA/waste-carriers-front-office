# frozen_string_literal: true

FactoryBot.define do
  factory :address, class: WasteCarriersEngine::Address do
    house_number { "42" }
    address_line_1 { "Foo Gardens" }
    town_city { "Baz City" }
    postcode { "FA1 1KE" }
    uprn { "340116" }

    trait :contact do
      address_type { "POSTAL" }
    end

    trait :registered do
      address_type { "REGISTERED" }
    end
  end
end
