class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :house_name
      t.string :street
      t.string :area
      t.integer :user_id
      t.string :geographic_id

      t.timestamps
    end
  end
end
