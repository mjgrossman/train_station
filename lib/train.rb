class Train

  attr_reader :name, :id

  def initialize(attributes)
    @name = attributes['name']
    @id = attributes['id']
  end

  def self.all
    trains = []
    results = DB.exec("SELECT * FROM train")
    results.each do |result|
      trains << Train.new(result)
    end
    trains
  end

  def ==(another_train)
    self.name == another_train.name
  end

  def save
    results = DB.exec("INSERT INTO train (name) VALUES ('#{@name}') RETURNING id;")
    @id = results.first['id'].to_i
  end

end
