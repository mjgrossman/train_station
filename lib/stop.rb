class Stop

  attr_reader :train_id, :station_id, :id

  def self.all
    stops = []
    results = DB.exec("SELECT * FROM stops")
    results.each do |result|
      stops << Stop.new(result)
    end
    stops
  end

  def self.delete_route(train)
    DB.exec("DELETE FROM stops WHERE train_id = '#{train}';")
  end

  def self.train_stops(input_id)
    results = DB.exec("SELECT * FROM stops WHERE train_id = '#{input_id}';")
    found_stations = []
    results.each do |result|
        found_stations << DB.exec("SELECT * FROM station WHERE id = '#{result['station_id']}';")
    end
    station_name = []
    found_stations.each do |station|
      station.each do |station_hash|
        station_name << station_hash
      end
    end
    station_name
  end

  def self.station_arrivals(input_id)
   results = DB.exec("SELECT * FROM stops WHERE station_id = '#{input_id}';")
    found_trains =[]
      results.each do |result|
        found_trains << DB.exec("SELECT * FROM train WHERE id = '#{result["train_id"]}';")
      end
    train_name =[]
    found_trains.each do |train_array|
      train_array.each do |train_hash|
        train_name << train_hash
      end
    end
    train_name
  end

  def initialize(attributes)
    @train_id = attributes['train_id']
    @station_id = attributes['station_id']
    @id = attributes['id']
  end

  def duplicate_stop_check
    Stop.all.each do |stop|
      if stop.train_id == self.train_id && stop.station_id == self.station_id
        return true
      else
        return false
      end
    end
  end

  def delete_stop
    DB.exec("DELETE FROM stops WHERE train_id = '#{self.train_id}' AND station_id = '#{self.station_id}';")
  end

  def self.update(hash)
    DB.exec("UPDATE stops SET station_id = '#{hash['new_station']}' WHERE train_id = '#{hash['train']}' AND station_id = '#{hash['old_station']}';")
    @station_id = hash['new_station']
  end

  def ==(another_stop)
    self.train_id == another_stop.train_id && self.station_id == another_stop.station_id
  end

  def save
    results = DB.exec("INSERT INTO stops (train_id, station_id) VALUES ('#{@train_id}', '#{@station_id}') RETURNING id;")
    @id = results.first['id'].to_i
  end

end
