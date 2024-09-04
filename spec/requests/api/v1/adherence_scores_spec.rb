require 'rails_helper'

RSpec.describe "Api::V1::AdherenceScores", type: :request do
  let!(:patient) { create(:patient) }
  let(:api_key) { patient.api_key }

  def json_response
    JSON.parse(response.body)
  end

  describe "GET /api/v1/patients/:patient_id/adherence_score" do
    context "when the patient exists" do
      it "returns the adherence score" do
        get api_v1_patient_adherence_score_path(patient), headers: { "Authorization" => "Bearer #{api_key}" }

        expect(response).to have_http_status(:success)
        expect(json_response['data']).to eq(
          "id" => patient.id.to_s,
          "type" => "patients",
          "attributes" => {
            "adherence_score" => patient.adherence_score
          }
        )
      end
    end

    context "when the patient does not exist" do
      it "returns unauthorized" do
        get api_v1_patient_adherence_score_path(patient_id: 9999), headers: { "Authorization" => "Bearer #{api_key}" }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when an invalid API key is provided" do
      it "returns unauthorized" do
        get api_v1_patient_adherence_score_path(patient), headers: { "Authorization" => "Bearer invalid_api_key" }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
