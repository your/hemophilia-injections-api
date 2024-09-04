class Api::V1::InjectionsController < ApplicationController
  include Authenticable

  def index
    patient = Patient.find(params[:patient_id])
    render jsonapi: patient.injections
  end

  def create
    patient = Patient.find(params[:patient_id])
    injection = patient.injections.new(injection_params)
    if injection.save
      render jsonapi: injection, status: :created
    else
      render jsonapi_errors: injection.errors, status: :unprocessable_entity
    end
  end

  private

  def injection_params
    params.require(:injection).permit(:dose_mm, :lot_number, :drug_name, :date)
  end
end
