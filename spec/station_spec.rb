require 'spec_helper'

describe Station do
  it 'initializes with a name' do
    test_station = Station.new({"name" => "Hollywood"})
    test_station.name.should eq "Hollywood"
  end
  it 'should start with an id of nill' do
    test_station = Station.new({"name" => "Hollywood"})
    test_station.id.should eq nil
  end
  it 'should have an id after you save it to the database' do
    test_station = Station.new({"name" => "Hollywood"})
    test_station.save
    test_station.id.should eq test_station.id
  end
  describe "save" do
    it 'saves the station to the database' do
      test_station = Station.new({"name" => "Hollywood"})
      test_station.save
      Station.all.should eq [test_station]
    end
  end
  # describe '.find' do
  #   it 'should find the station name when the id is given' do
  #     test_station = Station.new("name" => "Hollywood")
  #     test_train = Train.new("name" => "Blue")
  #     test_station.save
  #     test_train.save
  #     test_stop = Stop.new("train_id" => test_train.id, "station_id" => test_station.id)
  #     Station.find(test_stop.station_id).should eq "Hollywood"
  #   end
  # end
end
