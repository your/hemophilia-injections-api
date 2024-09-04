class CreateInjections < ActiveRecord::Migration[7.2]
  def change
    create_table :injections do |t|
      t.float :dose_mm
      t.string :lot_number, limit: 6
      t.string :drug_name
      t.date :date
      t.references :patient, null: false, foreign_key: true

      t.timestamps
    end

    add_index :injections, [:lot_number, :drug_name, :date], unique: true, name: 'index_injections_on_lot_number_and_drug_name_and_date'
  end
end
