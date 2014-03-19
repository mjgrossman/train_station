require 'rspec'
require 'train'
require 'station'
require 'stop'
require 'pg'

DB = PG.connect({:dbname => "train_station_test"})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM train *;")
    DB.exec("DELETE FROM station *;")
    DB.exec("DELETE FROM stops *;")
  end
end
