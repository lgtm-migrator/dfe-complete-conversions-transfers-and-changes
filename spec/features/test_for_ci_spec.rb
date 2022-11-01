require "rails_helper"

RSpec.feature "Team leaders can assign users to project roles" do
  let(:user) { create(:user) }

  before do
    sign_in_with_user(user)
  end

  scenario "something happens", driver: :headless_chromium do
    visit root_path

    expect(page).to have_content("Projects (0)")
  end
end
