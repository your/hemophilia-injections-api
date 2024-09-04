require 'rails_helper'

RSpec.describe 'Api::V1::Patients', type: :request do
  let(:valid_attributes) do
    {
      patient: {
        first_name: 'John',
        last_name: 'Doe',
        email: 'john.doe@example.com',
        date_of_birth: '1990-01-01'
      }
    }
  end

  let(:invalid_attributes) do
    {
      patient: {
        first_name: nil, # Invalid because first_name is required
        last_name: 'Doe',
        email: 'john.doe@example.com',
        date_of_birth: '1990-01-01'
      }
    }
  end

  def json_response
    JSON.parse(response.body)
  end

  describe 'POST /api/v1/patients' do
    context 'with valid parameters' do
      it 'creates a new Patient', :aggregate_failures do
        expect {
          post api_v1_patients_path, params: valid_attributes
        }.to change(Patient, :count).by(1)

        expect(response).to have_http_status(:created)
        patient = Patient.last
        expect(json_response['data']).to eq(
          "id" => patient.id.to_s,
          "type" => "patients",
          "attributes" => {
            "api_key" => patient.api_key
          }
        )
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Patient', :aggregate_failures do
        expect {
          post api_v1_patients_path, params: invalid_attributes
        }.to change(Patient, :count).by(0)

        expect(response).to have_http_status(:unprocessable_entity)

        expect(json_response['errors']).to eq(
          [{
            "title" => "Invalid first_name",
            "detail" => "First name can't be blank",
            "source" => {}
          }]
        )
      end
    end
  end
end
