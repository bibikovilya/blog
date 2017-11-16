class CreateRates < ActiveRecord::Migration[5.1]
  def change
    create_table :rates do |t|
      t.belongs_to :post_services, null: false
      t.integer :value, null: false
    end
  end
end
