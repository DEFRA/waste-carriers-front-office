# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Cookies", type: :feature do
  before { ENV["GOOGLE_TAGMANAGER_ID"] = "GA_ID" }

  let(:cookie_banner_div) { ".govuk-cookie-banner" }
  let(:google_analytics_render_tag) { "function(w,d,s,l,i)" }

  scenario "User accepts analytics cookies" do
    visit fo_path
    expect(page).to have_link("View cookies", href: "/pages/cookies")

    click_on "Accept analytics cookies"
    expect(page).to have_text("You’ve accepted analytics cookies")

    within cookie_banner_div do
      expect(page).to have_link("change your cookie settings", href: "/fo/pages/cookies")
      click_on "Hide this message"
    end

    expect(page).not_to have_css(cookie_banner_div)
    expect(page.source).to have_text(google_analytics_render_tag)
  end

  scenario "User rejects analytics cookies" do
    visit fo_path
    click_on "Reject analytics cookies"
    expect(page).to have_text("You’ve rejected analytics cookies")

    click_on "Hide this message"
    expect(page.source).not_to have_text(google_analytics_render_tag)
  end
end
