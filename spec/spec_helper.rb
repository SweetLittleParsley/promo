ENV['RACK_ENV'] = 'test'

require 'bundler'
Bundler.require(:default, :test)

ActiveRecord::Base.establish_connection adapter: 'postgresql', database: 'chic_test'

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :expect }
  config.order = 'random'
end
