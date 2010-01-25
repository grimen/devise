begin
  require 'mongo_mapper'
rescue LoadError
  begin
    gem 'mongo_mapper'
    require 'mongo_mapper'
  rescue LoadError
  end
end

if defined?(MongoMapper)
  begin
    MongoMapper.database = "devise-test-suite"
    MongoMapper.connection = Mongo::Connection.new('127.0.0.1', 27017) rescue raise

    require File.join(File.dirname(__FILE__), '..', 'rails_app', 'config', 'environment')
    require 'test_help'

    module MongoMapper::Document
      # TODO This should not be required
      def invalid?
        !valid?
      end
    end

    class ActiveSupport::TestCase
      setup do
        User.delete_all
        Admin.delete_all
      end
    end
  rescue
    puts "** ALERT: MongoDB could not be established to given host:port (127.0.0.1:27017). To run MongoMapper-tests for Devise, please ensure the MongoDB server is running."
  end
else
  puts "** ALERT: MongoMapper could not be loaded. To run MongoMapper-tests for Devise, please install MongoMapper gem using: sudo gem install mongo_mapper."
end