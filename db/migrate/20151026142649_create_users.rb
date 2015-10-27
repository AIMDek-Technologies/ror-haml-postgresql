class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :first_name
      t.string :last_name
      t.date :date_of_birth
      t.string :phone_number
      t.string :profile_pic_path
      t.string :role

      t.timestamps
    end
  end
end
