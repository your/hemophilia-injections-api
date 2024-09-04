class SerializablePatient < JSONAPI::Serializable::Resource
  type 'patients'

  attributes :id, :api_key
end
