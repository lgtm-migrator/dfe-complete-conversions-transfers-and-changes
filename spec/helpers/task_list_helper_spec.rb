require "rails_helper"

RSpec.describe TaskListHelper, type: :helper do
  describe "#task_status_id" do
    let(:task) { Task.new(title: "Clear land questionnaire") }

    it "returns the task title as kebab case with '-status' appended" do
      expect(helper.task_status_id(task)).to eq "clear-land-questionnaire-status"
    end
  end

  describe "#task_status_tag" do
    let(:task) { Task.new(title: "Clear land questionnaire") }

    it "returns a tag representing the task status when the status is known" do
      allow(task).to receive(:status).and_return(:completed)
      expect(helper.task_status_tag(task)).to eq '<strong class="govuk-tag govuk-tag--turquoise app-task-list__tag" id="clear-land-questionnaire-status">Completed</strong>'
    end

    it "returns a tag representing an unknown status where the status is not known" do
      allow(task).to receive(:status).and_return(:unexpected)
      expect(helper.task_status_tag(task)).to eq '<strong class="govuk-tag govuk-tag--grey app-task-list__tag" id="clear-land-questionnaire-status">Unknown</strong>'
    end
  end
end
