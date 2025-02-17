require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe "#render_markdown" do
    let(:markdown) { "[link](https://some-path.com)" }

    before { allow(GovukMarkdown).to receive(:render).and_call_original }

    subject! { helper.render_markdown(markdown) }

    it "calls the GovukMarkdown renderer" do
      expect(GovukMarkdown).to have_received(:render).with(markdown)
    end

    it "sets html_safe" do
      expect(subject.html_safe?).to be true
    end

    it "does not strip out target attributes" do
      expect(subject).to eq "<p class=\"govuk-body-m\"><a href=\"https://some-path.com\" class=\"govuk-link\" target=\"_blank\">link</a></p>"
    end

    context "when the hint option is true" do
      let(:markdown) { "Content" }

      subject! { helper.render_markdown(markdown, hint: true) }

      it "replaces the 'govuk-body-m' class with 'govuk-hint'" do
        expect(subject).to eq "<p class=\"govuk-hint\">Content</p>"
      end
    end
  end

  describe "#safe_link_to" do
    let(:body) { "Link" }
    let(:url) { "https://example.com" }

    subject { safe_link_to(body, url) }

    context "when the url contains unsafe protocols" do
      let(:url) { "javascript:alert('malicious')" }

      it "removes unsafe protocols" do
        expect(subject).to_not include("javascript")
      end
    end

    it "adds the target blank attribute" do
      expect(subject).to include("target=\"_blank\"")
    end
  end

  describe "#support_email" do
    let(:name) { "contact the complete conversions, transfers and changes team" }

    subject { helper.support_email(name) }

    it "returns a mailto link to the support email" do
      expect(subject).to eq "<a class=\"govuk-link\" href=\"mailto:complete.rsd@education.gov.uk\">#{name}</a>"
    end
  end
end
