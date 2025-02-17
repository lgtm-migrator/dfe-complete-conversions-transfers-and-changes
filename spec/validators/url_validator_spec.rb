require "rails_helper"

RSpec.describe UrlValidator do
  let(:link) { "https://example.com" }
  let(:testing_model) do
    Class.new do
      include ActiveModel::Model
      attr_accessor :link
      validates :link, url: {hostnames: %w[example another-example]}
    end
  end

  subject { testing_model.new(link: link) }

  context "when the URL is an invalid URI" do
    let(:link) { "/[invalid]" }

    it "is invalid" do
      expect(subject.valid?).to be false
      expect(subject.errors.first.type).to be :invalid
    end
  end

  context "when the URL scheme is not https" do
    let(:link) { "http://example.com" }

    it "is invalid" do
      expect(subject.valid?).to be false
      expect(subject.errors.first.type).to be :https_only
    end
  end

  context "when the URL hostname does not match" do
    let(:link) { "https://something-else.com" }

    it "is invalid" do
      expect(subject.valid?).to be false
      expect(subject.errors.first.type).to be :host_not_allowed
    end
  end

  context "when the URL matches the hostname and scheme" do
    %w[https://example.com https://another-example.com].each do |url|
      let(:link) { url }

      it "is valid" do
        expect(subject.valid?).to be true
      end
    end
  end
end
