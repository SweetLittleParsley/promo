module Promo
  class Usage
    class << self
      # Validates the use of any promocode
      # Options (Hash):
      #  code: string with the code used
      #  product_list: array with the products to be evaluated
      def validate (options={})
        promocode = Promo::Promocode.where("lower(code) = ?", options[:code].downcase).first
        raise InvalidPromocode.new 'promocode.messages.invalid' if promocode.nil?
        promocode.is_valid? options
      end

      # Calculates the discounts to any list of products
      # Options (Hash):
      #  promocode: Pomo::Promocode object
      #  product_list: array with the products to be evaluated
      def discount_for (options={})
        return 0 if options[:promocode].nil?
        promocode = options[:promocode]
        product_list = options[:product_list]

        return discount_for_product(promocode, product_list) if promocode.has_product?
        return discount_for_product_list_ids(promocode, product_list) if promocode.product_list.present?

        if promocode.is_percentage?
          total = product_list.map{ |i| i.single_value }.reduce(:+)
          val = calculate_percentage total, promocode.value
        else
          val = promocode.value
        end
        val
      end

      # Calculates the discount for a specific product in the list
      # previously associated with the current promocode
      # Parameters:
      #  promocode: Pomo::Promocode object
      #  product_list: array with the products to be evaluated
      def discount_for_product promocode, product_list
        product = promocode.product
        products = product_list.collect{|p| p.product}
        return 0 unless products.include? product
        if promocode.is_percentage?
          calculate_percentage(product.value,promocode.value)
        else
          promocode.value
        end
      end

      # Calculates the discount for a list of products based in the promocode list
      def discount_for_product_list_ids promocode, product_list_ids
        product_list_ids.each do |p|
          product_list_ids.delete(p) unless promocode.product_list.include? p.product_id
        end

        if promocode.is_percentage?
          total = product_list_ids.map{ |i| i.single_value }.reduce(:+)
          return (calculate_percentage total, promocode.value)
        else
          return 0 if product_list_ids.empty?
          return promocode.value
        end
      end

      #calculates the percentage to a specific value
      def calculate_percentage(value, percent)
        value = value || 0
        total = (value * (percent.to_f/100)).to_i
        total
      end
    end
  end
end
