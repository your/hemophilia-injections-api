class SerializableInjection < JSONAPI::Serializable::Resource
  type 'injections'

  attributes :dose_mm, :lot_number, :drug_name, :date
end
