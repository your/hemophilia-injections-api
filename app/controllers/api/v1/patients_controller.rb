class Api::V1::PatientsController < ApplicationController
  def create
    patient = Patient.new(patient_params)
    if patient.save
      render jsonapi: patient, fields: { patients: [:api_key] }, status: :created
    else
      render jsonapi_errors: patient.errors, status: :unprocessable_entity
    end
  end

  private

  def patient_params
    params.require(:patient).permit(:first_name, :last_name, :email, :date_of_birth)
  end
end
