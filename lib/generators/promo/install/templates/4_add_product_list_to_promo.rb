class AddMinimumPurchaseValueForPromocode < ActiveRecord::Migration
  def change
    add_column :promo_promocodes, :product_list, :integer, array: true
  end
end
