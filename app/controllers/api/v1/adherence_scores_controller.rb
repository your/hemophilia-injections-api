class Api::V1::AdherenceScoresController < ApplicationController
  include Authenticable

  def show
    patient = Patient.find(params[:patient_id])
    render jsonapi: patient, fields: { patients: [ :adherence_score ] }
  end
end
