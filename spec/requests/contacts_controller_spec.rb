require "rails_helper"

RSpec.describe ContactsController, type: :request do
  let(:user) { create(:user) }

  before do
    mock_successful_authentication(user.email)
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    allow_any_instance_of(ContactsController).to receive(:user_id).and_return(user.id)
  end

  describe "#index" do
    let(:project) { create(:project) }
    let(:project_id) { project.id }

    subject(:perform_request) do
      get project_contacts_path(project_id)
      response
    end

    context "when the Project is not found" do
      let(:project_id) { SecureRandom.uuid }

      it { expect { perform_request }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    it "returns a successful response" do
      expect(subject).to have_http_status :success
    end
  end

  describe "#new" do
    let(:project) { create(:project) }
    let(:project_id) { project.id }

    subject(:perform_request) do
      get new_project_contact_path(project_id)
      response
    end

    context "when the Project is not found" do
      let(:project_id) { SecureRandom.uuid }

      it { expect { perform_request }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    it "returns a successful response" do
      expect(subject).to have_http_status :success
    end
  end

  describe "#create" do
    let(:project) { create(:project) }
    let(:project_id) { project.id }
    let(:mock_contact) { build(:contact) }
    let(:new_contact_name) { "Josephine Bloggs" }
    let(:new_contact_title) { "Headteacher" }

    subject(:perform_request) do
      post project_contacts_path(project_id), params: {contact: {name: new_contact_name, title: new_contact_title}}
      response
    end

    context "when the Project is not found" do
      let(:project_id) { SecureRandom.uuid }

      it { expect { perform_request }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context "when the contact is invalid" do
      before do
        allow(Contact).to receive(:new).and_return(mock_contact)
        allow(mock_contact).to receive(:valid?).and_return false
      end

      it "renders the new template" do
        expect(perform_request).to render_template :new
      end
    end

    context "when the contact is valid" do
      it "saves the contact and redirects to the index view with a success message" do
        expect(subject).to redirect_to(project_contacts_path(project.id))
        expect(request.flash[:notice]).to eq(I18n.t("contact.create.success"))

        expect(Contact.count).to be 1
        expect(Contact.last.name).to eq(new_contact_name)
      end
    end
  end

  describe "#edit" do
    let(:project) { create(:project) }
    let(:project_id) { project.id }
    let(:contact) { create(:contact) }
    let(:contact_id) { contact.id }

    subject(:perform_request) do
      get edit_project_contact_path(project_id, contact_id)
      response
    end

    context "when the Project is not found" do
      let(:project_id) { SecureRandom.uuid }

      it { expect { perform_request }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context "when the Contact is not found" do
      let(:contact_id) { SecureRandom.uuid }

      it { expect { perform_request }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    it "returns a successful response" do
      expect(subject).to have_http_status :success
    end
  end

  describe "#update" do
    let(:project) { create(:project) }
    let(:project_id) { project.id }
    let(:contact) { create(:contact) }
    let(:contact_id) { contact.id }
    let(:new_contact_name) { "Josephine Bloggs" }
    let(:new_contact_title) { "Headteacher" }

    subject(:perform_request) do
      put project_contact_path(project_id, contact_id), params: {contact: {name: new_contact_name, title: new_contact_title}}
      response
    end

    context "when the Project is not found" do
      let(:project_id) { SecureRandom.uuid }

      it { expect { perform_request }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context "when the Contact is not found" do
      let(:contact_id) { SecureRandom.uuid }

      it { expect { perform_request }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context "when the contact is invalid" do
      before do
        allow(Contact).to receive(:find).and_return(contact)
        allow(contact).to receive(:valid?).and_return false
      end

      it "renders the edit template" do
        expect(perform_request).to render_template :edit
      end
    end

    context "when the contact is valid" do
      it "saves the contact and redirects to the index view with a success message" do
        expect(subject).to redirect_to(project_contacts_path(project.id))
        expect(request.flash[:notice]).to eq(I18n.t("contact.update.success"))

        expect(Contact.count).to be 1
        expect(Contact.last.name).to eq(new_contact_name)
        expect(Contact.last.title).to eq(new_contact_title)
      end
    end
  end

  describe "#destroy" do
    let(:project) { create(:project) }
    let(:project_id) { project.id }
    let(:contact) { create(:contact) }
    let(:contact_id) { contact.id }

    subject(:perform_request) do
      delete project_contact_path(project_id, contact_id)
      response
    end

    it "deletes the contact and redirects to the index view with a success message" do
      expect(perform_request).to redirect_to(project_contacts_path(project.id))
      expect(request.flash[:notice]).to eq(I18n.t("contact.destroy.success"))

      expect(Contact.where(id: contact_id)).to_not exist
    end
  end

  describe "#confirm_destroy" do
    let(:project) { create(:project) }
    let(:project_id) { project.id }
    let(:contact) { create(:contact) }
    let(:contact_id) { contact.id }

    subject(:perform_request) do
      get project_contact_delete_path(project_id, contact_id)
      response
    end

    it "returns a successful response" do
      expect(subject).to have_http_status :success
    end
  end
end
