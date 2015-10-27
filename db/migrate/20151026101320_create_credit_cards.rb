class CreateCreditCards < ActiveRecord::Migration
  def change
    create_table :credit_cards do |t|
      t.string :card_number
      t.date :valid_from_date
      t.date :valid_to_date
      t.string :cvv
      t.string :name_on_card
      t.datetime :statement_date
      t.integer :user_id
      t.float :credit_limit
      t.float :available_credit_limit
      t.integer :reward_points

      t.timestamps
    end
  end
end
