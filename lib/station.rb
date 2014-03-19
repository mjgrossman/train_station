class Station

  attr_reader :name, :id

  def initialize(attributes)
    @name = attributes['name']
    @id = attributes['id']
  end

  def save
    results = DB.exec("INSERT INTO station (name) VALUES ('#{@name}') RETURNING ID;")
    @id = results.first['id'].to_i
  end

  def ==(another_train)
    self.name == another_train.name
  end

  def self.all
    results = DB.exec("SELECT * FROM station;")
    stations = []
    results.each do |result|
      stations << Station.new(result)
    end
    stations
  end

  # def self.find(station_id)
  #   results = DB.exec("SELECT * FROM station WHERE id = '#{station_id}';")
  #   found_station = ''
  #     results.each do |result|
  #       found_station << result['name']
  #     end
  #     found_station
  # end


end
