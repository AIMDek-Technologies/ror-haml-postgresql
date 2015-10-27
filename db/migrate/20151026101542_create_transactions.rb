class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :credit_card_id
      t.float :amount
      t.datetime :transaction_date
      t.float :balance
      t.string :description
      t.integer :user_id

      t.timestamps
    end
  end
end
