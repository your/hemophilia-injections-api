module Authenticable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_patient!
  end

  private

  def authenticate_patient!
    api_key = request.headers['Authorization']&.split(' ')&.last
    unless valid_patient_api_key?(api_key)
      render json: {
        errors: [
          {
            title: 'Unauthorized',
            detail: 'API key is missing or invalid',
            code: '401'
          }
        ]
      }, status: :unauthorized
    end
  end

  def valid_patient_api_key?(api_key)
    api_key && params.key?(:patient_id) && Patient.exists?(id: params[:patient_id], api_key:)
  end
end
