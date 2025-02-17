require "rails_helper"

RSpec.describe "Sign in" do
  let(:user) { create(:user) }

  context "when the user is signed out" do
    it "redirects them to the sign in page and shows a helpful message" do
      get root_path

      expect(request).to redirect_to(sign_in_path)
      expect(flash.to_h.values).to include I18n.t("sign_in.message.unauthenticated")
    end
  end

  context "when the user is signed in" do
    before do
      mock_successful_authentication(user.email)
      allow_any_instance_of(ProjectsController).to receive(:user_id).and_return(user.id)
    end

    it "loads the requested page" do
      get root_path

      expect(response.body).to include(user.email)
      expect(response).to have_http_status(:success)
    end
  end

  context "when the users is not known by the application" do
    before { mock_successful_authentication("user@education.gov.uk") }

    it "redirects to the sign in page and shows a helpful message" do
      get "/auth/azure_activedirectory_v2/callback"

      expect(request).to redirect_to(sign_in_path)
      expect(flash.to_h.values).to include I18n.t("unknown_user.message", email_address: "user@education.gov.uk")
    end
  end
end
