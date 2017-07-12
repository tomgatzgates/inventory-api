class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.decimal :price, precision: 8, scale: 2, null: false
      t.string :option1
      t.string :option2
      t.string :option3

      t.timestamps
    end
  end
end
