# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Cookies" do
  let(:cookie_banner_div) { ".govuk-cookie-banner" }
  let(:google_analytics_render_tag) { "function(w,d,s,l,i)" }

  before { ENV["GOOGLE_TAGMANAGER_ID"] = "GA_ID" }

  # rubocop:disable RSpec/ExampleLength
  it "User accepts analytics cookies" do
    visit "/"
    expect(page).to have_link("View cookies", href: "/fo/pages/cookies")

    click_on "Accept analytics cookies"
    expect(page).to have_text("You’ve accepted analytics cookies")
    expect(get_me_the_cookie("cookies_policy")[:value]).to eq "analytics_accepted"

    within cookie_banner_div do
      expect(page).to have_link("change your cookie settings", href: "/cookies/edit")
      click_on "Hide this message"
    end

    expect(page).to have_no_css(cookie_banner_div)
  end
  # rubocop:enable RSpec/ExampleLength

  # rubocop:disable RSpec/ExampleLength
  it "User rejects analytics cookies and toggles their selection" do
    visit "/"
    click_on "Reject analytics cookies"
    expect(page).to have_text("You’ve rejected analytics cookies")

    click_on "change your cookie settings"
    expect(page).to have_css("h1", text: "Cookie settings on Register as a waste carrier")

    choose "Use cookies that measure my website use"
    click_on "Save changes"
    expect(page).to have_text("You’ve set your cookie preferences.")
    expect(get_me_the_cookie("cookies_policy")[:value]).to eq "analytics_accepted"

    choose "Do not use cookies that measure my website use"
    click_on "Save changes"
    expect(page).to have_text("You’ve set your cookie preferences.")
    expect(get_me_the_cookie("cookies_policy")[:value]).to eq "analytics_rejected"

  end
  # rubocop:enable RSpec/ExampleLength
end
