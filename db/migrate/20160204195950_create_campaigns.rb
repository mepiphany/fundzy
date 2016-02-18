class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :name
      t.text :description
      t.integer :goal
      t.datetime :end_date

      t.timestamps null: false
    end
  end
end
