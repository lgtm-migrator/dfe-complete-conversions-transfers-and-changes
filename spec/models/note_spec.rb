require "rails_helper"

RSpec.describe Note, type: :model do
  describe "Columns" do
    it { is_expected.to have_db_column(:body).of_type :text }
  end

  describe "Relationships" do
    it { is_expected.to belong_to(:project) }
    it { is_expected.to belong_to(:user) }
  end

  describe "Validations" do
    describe "#body" do
      it { is_expected.to validate_presence_of(:body) }
      it { is_expected.to_not allow_values("", nil).for(:body) }
    end
  end

  describe "Scopes" do
    describe "default_scope" do
      before do
        mock_successful_api_responses(urn: any_args, ukprn: any_args)

        freeze_time
        travel_to(Date.yesterday) { create(:note, body: "Yesterday's note.") }
        create(:note, body: "Today's note.")
      end

      it "orders descending by the 'created_at' attribute" do
        expect(Note.first.body).to eq "Today's note."
      end
    end
  end
end
