require 'spec_helper'

describe Stop do
  it 'initializes with a train_id' do
    test_stop = Stop.new({"train_id" => '1', "station_id" => '3'})
    test_stop.train_id.should eq '1'
  end
  it 'initializes with a station_id' do
    test_stop = Stop.new({"train_id" => '1', "station_id" => '3'})
    test_stop.station_id.should eq '3'
  end
  it 'should have an id after you save it to the database' do
    test_stop = Stop.new({"train_id" => '1', "station_id" => '3'})
    test_stop.save
    test_stop.id.should eq test_stop.id
  end
  describe "save" do
    it 'saves the stop to the database' do
      test_stop = Stop.new({"train_id" => '1', "station_id" => '3'})
      test_stop.save
      Stop.all.should eq [test_stop]
    end
  end
  describe '.train_stops' do
    it 'should give you the route of the train' do
      test_station = Station.new("name" => "Hollywood")
      test_train = Train.new("name" => "Blue")
      test_station.save
      test_train.save
      test_stop = Stop.new("train_id" => test_train.id, "station_id" => test_station.id)
      test_stop.save
      Stop.train_stops(test_stop.train_id).should eq [{"id" => "#{test_station.id}", "name" => "Hollywood"}]
    end
  end
  describe '.station_arrivals' do
    it 'all the trains that visit a station' do
      test_station = Station.new("name" => "Hollywood")
      test_train = Train.new("name" => "Blue")
      test_train2 = Train.new("name" => "Green")
      test_station.save
      test_train.save
      test_train2.save
      test_stop = Stop.new("train_id" => test_train.id, "station_id" => test_station.id)
      test_stop2 = Stop.new("train_id" => test_train2.id, "station_id" => test_station.id)
      test_stop.save
      test_stop2.save
      Stop.station_arrivals(test_stop.station_id).should eq [{"id" => "#{test_train.id}", "name" => "Blue"}, {"id" => "#{test_train2.id}", "name" => "Green"}]
    end
  end
  describe "duplicate_stop_check" do
    it 'will check if a stop is already in the database' do
      test_stop = Stop.new({"train_id" => '1', "station_id" => '1'})
      test_stop.save
      test_stop2 = Stop.new({"train_id" => '1', "station_id" => '1'})
      test_stop2.duplicate_stop_check.should eq true
    end
  end
  describe 'delete_stop' do
    it 'should remove stops' do
      test_stop = Stop.new({"train_id" => '1', "station_id" => '1'})
      test_stop.save
      test_stop.delete_stop
      Stop.all.should eq []
    end
  end
  describe 'delete_route' do
    it 'should remove an entire route for a train' do
      test_stop = Stop.new({"train_id" => '1', "station_id" => '1'})
      test_stop2 = Stop.new({"train_id" => '1', "station_id" => '1'})
      test_stop3 = Stop.new({"train_id" => '2', "station_id" => '1'})
      test_stop3.save
      test_stop.save
      test_stop2.save
      Stop.delete_route('1')
      Stop.all.should eq [test_stop3]
    end
  end
  describe 'update' do
    it 'will change the station for a stop' do
      test_stop = Stop.new({"train_id" => '1', "station_id" => '1'})
      test_stop.save
      Stop.update({"old_station" => "1", "train" => "1", "new_station" => "4"})
      Stop.all.last.station_id.should eq "4"
    end
  end
end

