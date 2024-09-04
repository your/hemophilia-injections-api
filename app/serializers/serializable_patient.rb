class SerializablePatient < JSONAPI::Serializable::Resource
  type "patients"

  attributes :id, :api_key

  attribute :adherence_score do
    @object.adherence_score
  end
end
