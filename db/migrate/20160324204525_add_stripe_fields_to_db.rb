class AddStripeFieldsToDb < ActiveRecord::Migration
  def change
    add_column :pledges, :stripe_txn_id, :string

    add_column :users, :stripe_customer_id, :string
    add_column :users, :stripe_last_4, :string
    add_column :users, :stripe_card_type, :string
    add_column :users, :stripe_card_expiry_month, :integer
    add_column :users, :stripe_card_expiry_year, :integer
  end
end
