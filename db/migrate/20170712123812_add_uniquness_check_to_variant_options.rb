class AddUniqunessCheckToVariantOptions < ActiveRecord::Migration[5.1]
  def change
    add_index :variants,
              [:product_id, :option1, :option2, :option3],
              unique: true,
              name: 'unique_product_variant'
  end
end
