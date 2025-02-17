require "rails_helper"

RSpec.feature "Users can view a list of projects" do
  before do
    mock_successful_api_responses(urn: 100001, ukprn: 10061021)
    mock_successful_api_responses(urn: 100002, ukprn: 10061021)
    mock_successful_api_responses(urn: 100003, ukprn: 10061021)
    mock_successful_api_responses(urn: 100004, ukprn: 10061021)
  end

  let(:team_leader) { create(:user, :team_leader, email: "teamleader@education.gov.uk") }
  let(:regional_delivery_officer) { create(:user, :regional_delivery_officer, email: "regionaldeliveryofficer@education.gov.uk") }
  let(:user_1) { create(:user, email: "user1@education.gov.uk") }
  let(:user_2) { create(:user, email: "user2@education.gov.uk") }
  let!(:unassigned_project) {
    create(
      :project,
      urn: 100001,
      target_completion_date: Date.today.beginning_of_month + 3.years
    )
  }
  let!(:user_1_project) {
    create(
      :project,
      urn: 100002,
      caseworker: user_1,
      target_completion_date: Date.today.beginning_of_month + 2.year
    )
  }
  let!(:user_2_closed_project) {
    create(
      :project,
      urn: 100004,
      caseworker: user_2,
      regional_delivery_officer: regional_delivery_officer,
      target_completion_date: Date.today.beginning_of_month + 6.months,
      closed_at: Date.today.beginning_of_month + 7.months
    )
  }
  let!(:user_2_project) {
    create(
      :project,
      urn: 100003,
      caseworker: user_2,
      regional_delivery_officer: regional_delivery_officer,
      target_completion_date: Date.today.beginning_of_month + 1.years
    )
  }

  context "when the user is a team leader" do
    before do
      sign_in_with_user(team_leader)
    end

    scenario "can see all projects on the project list regardless of assignment" do
      visit projects_path

      page_has_project(unassigned_project)
      page_has_project(user_1_project)
      page_has_project(user_2_project)
      page_has_project(user_2_closed_project)
    end

    # If this is unexpectedly failing due to sorting closed projects first, see the by_closed_state scope in the
    # projects model for an explanation of the likely culprit.
    scenario "the projects are sorted by closed state, then by target completion date" do
      visit projects_path

      expect(page.find("ul.projects-list > li:nth-of-type(1)")).to have_content("100003")
      expect(page.find("ul.projects-list > li:nth-of-type(2)")).to have_content("100002")
      expect(page.find("ul.projects-list > li:nth-of-type(3)")).to have_content("100001")
      expect(page.find("ul.projects-list > li:nth-of-type(4)")).to have_content("100004")
    end
  end

  context "when the user is a regional delivery officer" do
    before do
      sign_in_with_user(regional_delivery_officer)
    end

    scenario "can only see assigned projects on the projects list" do
      visit projects_path

      expect(page).to_not have_content(unassigned_project.urn.to_s)
      expect(page).not_to have_content(user_1_project.urn.to_s)
      page_has_project(user_2_project)
    end
  end

  context "when the user does not have an assigned role" do
    before(:each) do
      sign_in_with_user(user_1)
    end

    scenario "can only see assigned projects on the projects list" do
      visit projects_path

      expect(page).to_not have_content(unassigned_project.urn.to_s)
      expect(page).to have_content(user_1_project.urn.to_s)
      expect(page).to_not have_content(user_2_project.urn.to_s)
    end
  end

  private def page_has_project(project)
    urn = find("span", text: project.urn.to_s)

    within urn.ancestor("li") do
      expect(page).to have_content("School type: #{project.establishment.type}")
      expect(page).to have_content("Target conversion date: #{project.target_completion_date.to_formatted_s(:govuk)}")
      expect(page).to have_content("Incoming trust: #{project.incoming_trust.name}")
      expect(page).to have_content("Local authority: #{project.establishment.local_authority}")
    end
  end
end

RSpec.feature "Users can view a single project" do
  let(:urn) { 123456 }
  let(:establishment) { build(:academies_api_establishment) }

  before do
    mock_successful_api_establishment_response(urn: urn, establishment: establishment)
    mock_successful_api_responses(urn: urn, ukprn: 10061021)
  end

  scenario "by following a link from the home page" do
    sign_in_with_user(create(:user, :team_leader))

    single_project = create(:project, urn: urn)

    visit root_path
    click_on establishment.name
    expect(page).to have_content(single_project.urn.to_s)
  end

  context "when a project does not have an assigned caseworker" do
    scenario "the project page shows an unassigned caseworker" do
      sign_in_with_user(create(:user, :team_leader))
      single_project = create(:project, urn: urn)

      visit project_information_path(single_project)
      expect(page).to have_content(I18n.t("project.summary.caseworker.unassigned"))
    end
  end
end
