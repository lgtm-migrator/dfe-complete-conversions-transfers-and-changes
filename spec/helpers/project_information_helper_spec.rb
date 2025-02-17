require "rails_helper"

RSpec.describe ProjectInformationHelper, type: :helper do
  describe "#age_range" do
    context "when the lower age range is nil" do
      let(:establishment) { build(:academies_api_establishment, age_range_lower: nil) }

      it "returns nil" do
        expect(helper.age_range(establishment)).to be_nil
      end
    end

    context "when the upper age range is nil" do
      let(:establishment) { build(:academies_api_establishment, age_range_upper: nil) }

      it "returns nil" do
        expect(helper.age_range(establishment)).to be_nil
      end
    end

    context "when both upper and lower ranges have values" do
      let(:establishment) { build(:academies_api_establishment) }

      it "returns a formatted date range" do
        expect(helper.age_range(establishment)).to eq "11 to 18"
      end
    end
  end

  describe "#display_name" do
    subject { helper.display_name(user) }

    context "when user is nil" do
      let(:user) { nil }

      it "returns a 'Not yet assigned' message" do
        expect(subject).to eq t("project_information.show.project_details.rows.unassigned")
      end
    end

    context "when full name is present" do
      let(:user) { build(:user) }

      it "returns the full name" do
        expect(subject).to eq "John Doe"
      end
    end
  end

  describe "#mail_to_path" do
    subject { helper.mail_to_path("john.doe@education.gov.uk") }

    it "returns a `mailto` path (not wrapped in a link)" do
      expect(subject).to eq "mailto:john.doe@education.gov.uk"
    end
  end
end
