require "rails_helper"

RSpec.describe AcademiesApi::Client do
  it "uses the environment variables to build the connection" do
    ClimateControl.modify(
      ACADEMIES_API_HOST: "https://test.academies.api",
      ACADEMIES_API_KEY: "api-key"
    ) do
      client_connection = described_class.new.connection

      expect(client_connection.scheme).to eql "https"
      expect(client_connection.host).to eql "test.academies.api"
      expect(client_connection.headers["ApiKey"]).to eql "api-key"
      expect(client_connection.options[:timeout]).to eql AcademiesApi::Client::ACADEMIES_API_TIMEOUT
    end
  end

  describe "#get_establishment" do
    let(:client) { described_class.new(connection: fake_successful_establishment_connection(12345678, fake_response)) }

    context "when the establishment can be found" do
      let(:fake_response) { [200, nil, {establishmentName: "Establishment Name"}.to_json] }

      it "returns a Result with the establishment and no error" do
        result = client.get_establishment(12345678)

        expect(result.object.name).to eql("Establishment Name")
        expect(result.error).to be_nil
      end
    end

    context "when the establishment cannot be found" do
      let(:fake_response) { [404, nil, nil] }

      it "returns a Result with a NotFoundError and no establishment" do
        the_result = client.get_establishment(12345678)

        expect(the_result.object).to be_nil
        expect(the_result.error).to be_a(AcademiesApi::Client::NotFoundError)
      end
    end

    context "when there is any other error" do
      let(:fake_response) { [500, nil, nil] }

      it "returns a Result with an Error and no establishment" do
        the_result = client.get_establishment(12345678)

        expect(the_result.object).to be_nil
        expect(the_result.error).to be_a(AcademiesApi::Client::Error)
      end
    end

    context "when the connection fails" do
      it "raises an Error" do
        client = described_class.new(connection: fake_failed_establishment_connection(12345678))

        expect { client.get_establishment(12345678) }.to raise_error(AcademiesApi::Client::Error)
      end
    end
  end

  def fake_successful_establishment_connection(urn, response)
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get("/establishment/urn/#{urn}") do |env|
          response
        end
      end
    end
  end

  def fake_failed_establishment_connection(urn)
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get("/establishment/urn/#{urn}") do |env|
          raise Faraday::Error
        end
      end
    end
  end

  describe "#get_trust" do
    let(:client) { described_class.new(connection: fake_successful_trust_connection(10061021, fake_response)) }

    context "when the trust can be found" do
      let(:fake_response) { [200, nil, {data: {giasData: {groupName: "THE ROMERO CATHOLIC ACADEMY"}}}.to_json] }

      it "returns a Result with the establishment and no error" do
        result = client.get_trust(10061021)

        expect(result.object.original_name).to eql("THE ROMERO CATHOLIC ACADEMY")
        expect(result.error).to be_nil
      end

      it "correctly titleises the trust name" do
        result = client.get_trust(10061021)

        expect(result.object.name).to eql("The Romero Catholic Academy")
      end
    end

    context "when the trust cannot be found" do
      let(:fake_response) { [404, nil, nil] }

      it "returns a Result with a NotFoundError and no establishment" do
        the_result = client.get_trust(10061021)

        expect(the_result.object).to be_nil
        expect(the_result.error).to be_a(AcademiesApi::Client::NotFoundError)
      end
    end

    context "when there is any other error" do
      let(:fake_response) { [500, nil, nil] }

      it "returns a Result with an Error and no trust" do
        the_result = client.get_trust(10061021)

        expect(the_result.object).to be_nil
        expect(the_result.error).to be_a(AcademiesApi::Client::Error)
      end
    end

    context "when the connection fails" do
      it "raises an Error" do
        client = described_class.new(connection: fake_failed_trust_connection(10061021))

        expect { client.get_trust(10061021) }.to raise_error(AcademiesApi::Client::Error)
      end
    end
  end

  def fake_successful_trust_connection(ukprn, response)
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get("/v2/trust/#{ukprn}") do |env|
          response
        end
      end
    end
  end

  def fake_failed_trust_connection(ukprn)
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get("/v2/trust/#{ukprn}") do |env|
          raise Faraday::Error
        end
      end
    end
  end
end
