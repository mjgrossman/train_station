require 'spec_helper'

describe Train do
  it 'should initialize with a name' do
    test_train = Train.new({ "name" => "Blue" })
    test_train.name.should eq "Blue"
  end
  it 'should start with an id of nill' do
    test_train = Train.new({"name" => "Blue"})
    test_train.id.should eq nil
  end
  it 'should have an id after you save it to the database' do
    test_train = Train.new({"name" => "Blue"})
    test_train.save
    test_train.id.should eq test_train.id
  end
  describe '.all' do
    it 'should pull all of the trains from the database into an array' do
      test_train = Train.new({ "name" => "Blue" })
      test_train.save
      Train.all.should eq [test_train]
    end
  end
end

