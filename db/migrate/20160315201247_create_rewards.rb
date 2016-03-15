class CreateRewards < ActiveRecord::Migration
  def change
    create_table :rewards do |t|
      t.references :campaign, index: true, foreign_key: true
      t.string :title
      t.integer :amount

      t.timestamps null: false
    end
  end
end
