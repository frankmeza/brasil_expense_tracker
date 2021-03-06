ENV['RACK_ENV'] = 'test'
$VERBOSE=nil

require_relative '../app'
require_relative '../dependencies'
require 'minitest/reporters'
require 'minitest/autorun'
require 'factory_bot'
require 'rack/test'
require 'faker'
require 'pry'

Minitest::Reporters.use! [ Minitest::Reporters::DefaultReporter.new ]
FactoryBot.definition_file_paths = %w{ ./test/factories }
FactoryBot.find_definitions

class RackTest < MiniTest::Test
  include Rack::Test::Methods
  include FactoryBot::Syntax::Methods

  def app
    Brasil
  end

  def clean_data
    Mongoid::Config.purge!
    User.all.delete
    Expense.all.delete
  end

  def login_this(user)
    credentials = { login: user.username, password: 'password' }
    post '/auth/login', credentials.to_json
  end

  def res
    last_response
  end

  def res_as_json
    JSON.parse(res.body)
  end

  # useful stuff I've found that's helped while testing:
  # http://ryanbigg.com/2014/08/add-header-to-rack-test-request
end
