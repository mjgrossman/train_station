require './lib/train'
require './lib/station'
require './lib/stop'
require 'pg'

DB = PG.connect({:dbname => "train_station"})

def main_menu
  puts "\nWelcome to the Train System UI"
  puts "For the Operator menu press - O"
  puts "For the Train Rider menu press - R"
  puts "To exit the Train System press - X"

  case gets.chomp.upcase
    when "O"
      operator_main_menu
    when "R"
      rider_main_menu
    when "X"
      puts "Seya!"
    else
      puts "That is not an option"
      main_menu
    end
end

def operator_main_menu
  puts "\nWelcome optimus"
  puts "To add a train press - AT"
  puts "To add a station press - AS"
  puts "To list all trains press - LT"
  puts "To list all stations press - LS"
  puts "To create a route press - R"
  puts "To edit a route press - E"
  puts "To return to main menu press - M"

  case gets.chomp.upcase
    when "R"
      create_route
      operator_main_menu
    when "LT"
      list_train
      operator_main_menu
    when "LS"
      list_station
      operator_main_menu
    when "AT"
      add_train
      operator_main_menu
    when "AS"
      add_station
      operator_main_menu
    when "E"
      edit_route
      operator_main_menu
    when "M"
      main_menu
    else
      "Not a valid input"
      operator_main_menu
    end
end

def edit_route
  edit_hash = {}
  list_train
  puts "\nEnter the ID number of the train you would like to view a route for:"
  edit_hash['train'] = gets.chomp
  puts "\nList of stations on that route:"
  Stop.train_stops(edit_hash['train']).each do |station|
    puts "#{station['id']}) #{station['name']}"
  end
  puts "Pick a station to change its station"
  edit_hash['old_station'] = gets.chomp
  list_station
  puts "Pick a new station"
  edit_hash['new_station'] = gets.chomp
  Stop.update(edit_hash)
  Stop.train_stops(edit_hash['train']).each do |station|
    puts "#{station['id']}) #{station['name']}"
  end
end

def add_train
  train_hash = {}
  puts "\nEnter a train to add to the system:"
  train_hash['name'] = gets.chomp.capitalize
  Train.new(train_hash).save
  puts "you added #{train_hash['name']} to your system"
end

def add_station
  station_hash = {}
  puts "\nEnter a station to add to the system"
  station_hash['name'] = gets.chomp.capitalize
  Station.new(station_hash).save
  puts "you added #{station_hash['name']} to your system"
end

def list_train
  puts "\nList of all trains:"
  Train.all.each do |train|
    puts "#{train.id}) #{train.name}"
  end
end

def list_station
  puts "\nList of all stations:"
  Station.all.each do |station|
    puts "#{station.id}) #{station.name}"
  end
end

def create_route
  puts "\nList of all trains:"
  available_trains.each do |train|
    puts "#{train.id}) #{train.name}"
  end
  puts "=========="
  puts "\nEnter the ID number of the train you would like to create a route for:"
  train_input = gets.chomp
  station_select(train_input)
end

def station_select(train_input)
  stop_hash = {"train_id" => train_input}
  puts "\n\nList of all stations:"
  Station.all.each do |station|
    puts "#{station.id}) #{station.name}"
  end
  puts "=========="
  puts "\nEnter the ID number of the station you you would like to add to the route"
  stop_hash['station_id'] = gets.chomp

  if Stop.new(stop_hash).duplicate_stop_check == true
    puts "Stop already in train system!"
    station_select(train_input)
  else
    Stop.new(stop_hash).save
    puts "Added stop #{stop_hash['station_id']} to #{stop_hash['train_id']}"
    puts "\nWould you like to add another stop to your route? (Yes/No)"
    case gets.chomp.capitalize
    when "Yes"
      station_select(train_input)
    else
      operator_main_menu
    end
  end
end

def rider_main_menu
  puts "\nWelcome passenger"
  puts "To view the route for a particular train press - R"
  puts "To view the train lines that stop at a particular station press - S"
  puts "To return to main menu press - M"

  case gets.chomp.upcase
    when "R"
      view_route
      rider_main_menu
    when "S"
      view_stations
      rider_main_menu
    when "M"
      main_menu
    else
      "Not a valid input"
      rider_main_menu
    end
end

def view_route
  list_train
  puts "\nEnter the ID number of the train you would like to view a route for:"
  Stop.train_stops(gets.chomp).each do |station|
    puts "#{station['id']}) #{station['name']}"
  end
end

def view_stations
  list_station
  puts "\nEnter the ID number of the station you would like to view all of the trains that visit there:"
  Stop.station_arrivals(gets.chomp).each do |train|
    puts "#{train['id']}) #{train['name']}"
  end
end

# def available_stations
#   stations = Station.all
#   stations.each do |station|
#     Stop.all.each do |stop|
#       stations.delete_if { |station| station.id == stop.station_id }
#     end
#   end
#   stations
# end

def available_trains
  trains = Train.all
  trains.each do |train|
    Stop.all.each do |stop|
      trains.delete_if { |train| train.id == stop.train_id }
    end
  end
  trains
end

main_menu
