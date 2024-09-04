require 'rails_helper'

RSpec.describe "Api::V1::Injections", type: :request do
  let!(:patient) { create(:patient) }
  let(:api_key) { patient.api_key }
  let(:valid_attributes) do
    {
      injection: {
        dose_mm: 10.0,
        lot_number: "LOT123",
        drug_name: "Drug A",
        date: "2023-01-01"
      }
    }
  end

  let(:invalid_attributes) do
    {
      injection: {
        dose_mm: nil, # Invalid because dose_mm is required
        lot_number: "LOT123",
        drug_name: "Drug A",
        date: "2023-01-01"
      }
    }
  end

  def json_response
    JSON.parse(response.body)
  end

  describe "GET /api/v1/patients/:patient_id/injections" do
    let!(:first_injection) { create(:injection, patient:) }
    let!(:second_injection) { create(:injection, patient:) }

    context "with valid API key" do
      it "returns a list of injections for the patient" do
        get api_v1_patient_injections_path(patient), headers: { "Authorization" => "Bearer #{api_key}" }

        expect(response).to have_http_status(:success)
        expect(json_response['data']).to eq(
          [
            {
              "id" => first_injection.id.to_s,
              "type" => "injections",
              "attributes" => {
                "dose_mm" => first_injection.dose_mm,
                "drug_name" => first_injection.drug_name,
                "lot_number" => first_injection.lot_number,
                "date" => first_injection.date.as_json
              },
            },
            {
              "id" => second_injection.id.to_s,
              "type" => "injections",
              "attributes" => {
                "dose_mm" => second_injection.dose_mm,
                "drug_name" => second_injection.drug_name,
                "lot_number" => second_injection.lot_number,
                "date" => second_injection.date.as_json
              }
            }
          ]
        )
      end
    end

    context "with invalid API key" do
      it "returns unauthorized" do
        get api_v1_patient_injections_path(patient), headers: { "Authorization" => "Bearer invalid_key" }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /api/v1/patients/:patient_id/injections" do
    context "with valid parameters" do
      it "creates a new Injection" do
        expect {
          post api_v1_patient_injections_path(patient), params: valid_attributes, headers: { "Authorization" => "Bearer #{api_key}" }
        }.to change(Injection, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(json_response['data']).to include(
          "id" => Injection.last.id.to_s,
          "type" => "injections",
          "attributes" => {
            "dose_mm" => valid_attributes[:injection][:dose_mm],
            "drug_name" => valid_attributes[:injection][:drug_name],
            "lot_number" => valid_attributes[:injection][:lot_number],
            "date" => valid_attributes[:injection][:date]
          }
        )
      end
    end

    context "with invalid parameters" do
      it "does not create a new Injection" do
        expect {
          post api_v1_patient_injections_path(patient), params: invalid_attributes, headers: { "Authorization" => "Bearer #{api_key}" }
        }.to change(Injection, :count).by(0)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to eq(
          [{
            "title" => "Invalid dose_mm",
            "detail" => "Dose mm can't be blank",
            "source" => {}
          }]
        )
      end
    end
  end
end
