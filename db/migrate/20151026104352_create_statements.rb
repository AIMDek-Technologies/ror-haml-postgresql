class CreateStatements < ActiveRecord::Migration
  def change
    create_table :statements do |t|
      t.integer :credit_card_id
      t.datetime :statement_date
      t.datetime :from_date
      t.datetime :to_date
      t.float :amount_due
      t.string :file_path
      t.integer :user_id

      t.timestamps
    end
  end
end
