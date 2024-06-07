class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.integer :amount
      t.string :stripe_charge_id
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
