class CreateMetafields < ActiveRecord::Migration[5.1]
  def change
    create_table :metafields do |t|
      t.references :product, index: true, null: false
      t.string :key, null: false
      t.string :value, null: false
      t.string :prefix
      t.string :suffix

      t.timestamps
    end
  end
end
