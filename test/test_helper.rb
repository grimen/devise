require 'rubygems'

ENV["RAILS_ENV"] = "test"
DEVISE_ORM = (ENV["DEVISE_ORM"] || :active_record).to_sym

puts "\n==> Devise.orm = #{DEVISE_ORM.inspect}"
require File.join(File.dirname(__FILE__), 'orm', DEVISE_ORM.to_s)

require 'test/unit'
require 'webrat'
require 'mocha'
require 'active_support'
require 'action_controller'
require 'action_view'
require 'action_mailer'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

ActiveSupport::TestCase.class_eval do
  include Devise::AssertionsHelper
  include Devise::ModelTestsHelper
end

ActionController::IntegrationTest.class_eval do
  include ::Devise::IntegrationTestsHelper
end

ActionMailer::Base.delivery_method = :test
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.default_url_options[:host] = 'test.com'

Webrat.configure do |config|
  config.mode = :rails
  config.open_error_files = false
end