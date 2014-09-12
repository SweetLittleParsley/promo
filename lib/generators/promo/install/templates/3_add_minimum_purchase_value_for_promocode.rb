class CreatePromoMinimumPurchaseValue < ActiveRecord::Migration
  def change
    add_column :promo_promocodes, :minimum_purchase_value, :integer
  end
end
