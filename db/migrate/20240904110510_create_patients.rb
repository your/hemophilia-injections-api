class CreatePatients < ActiveRecord::Migration[7.2]
  def change
    create_table :patients do |t|
      t.string :first_name
      t.string :last_name
      t.string :email, null: false
      t.date :date_of_birth
      t.string :api_key, null: false

      t.timestamps
    end

    add_index :patients, :email, unique: true
    add_index :patients, [:id, :api_key], unique: true, name: 'index_patients_on_id_and_api_key'
  end
end
