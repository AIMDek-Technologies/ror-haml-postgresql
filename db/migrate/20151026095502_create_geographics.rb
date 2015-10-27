class CreateGeographics < ActiveRecord::Migration
  def change
    create_table :geographics do |t|
      t.string :zip_code
      t.string :country
      t.string :state
      t.string :city

      t.timestamps
    end
  end
end
