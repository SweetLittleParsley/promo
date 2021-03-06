# encoding: utf-8

module Promo
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc 'Creates the models to the file'

      def self.source_root
        @_promo_source_root ||= File.expand_path("../templates", __FILE__)
      end

      def create_migration_files
        time = Time.now.strftime("%Y%m%d%H%M%S").to_i
        if Dir[File.join('db', 'migrate', '*_create_promo_promocode*')].empty?
          template '1_create_promo_promocode.rb', File.join('db', 'migrate', "#{time}_create_promo_promocode.rb")
        end
        if Dir[File.join('db', 'migrate', '*_create_promo_history*')].empty?
          template '2_create_promo_history.rb', File.join('db', 'migrate', "#{time+1}_create_promo_history.rb")
        end
        if Dir[File.join('db', 'migrate', '*_add_minimum_purchase_value_for_promocode*')].empty?
          template '3_add_minimum_purchase_value_for_promocode.rb', File.join('db', 'migrate', "#{time+2}_add_minimum_purchase_value_for_promocode.rb")
        end
        if Dir[File.join('db', 'migrate', '*_add_product_list_to_promo*')].empty?
          template '4_add_product_list_to_promo.rb', File.join('db', 'migrate', "#{time+3}_add_product_list_to_promo.rb")
        end
      end

    end
  end
end
