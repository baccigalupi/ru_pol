require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe RuPol::Pool do
  before do
    @pool = RuPol::Pool.new(2, Array)
    @empty_stats = {
      :gets => 0,
      :pushes => 0,
      :overage => 0
    }
    @arrays = [
      [1], [2], [3]
    ]
  end
  
  describe 'initialization' do
    it 'should require two arguments, first for the size, second for the class being stored' do  
      lambda{ RuPol::Pool.new }.should raise_error
    end
  
    it 'sets the max size' do
      @pool.max_size.should == 2
    end
    
    it 'sets the instance_class' do
      @pool.instance_class.should == Array
    end
    
    it 'sets the stats to empty' do
      @pool.stats.should == @empty_stats
    end
    
    it 'calculates and caches #clearable' do
      @pool.clearable.should == true
    end
    
    it 'calculates and caches #recycledable' do
      @pool.recycledable.should == false
    end
    
    it 'should have a cache' do
      @pool.cache.should == []
    end
  end
  
  describe 'delegates' do
    it 'should have a size that corresponds to the cache size' do
      @pool.size.should == 0
      @pool.cache.size.should == 0
    
      @pool.cache << ['foo']
      @pool.size.should == 1
    end
    
    it 'should know if it has room' do
      @pool.available?.should be_true
      @pool << @arrays[0]
      @pool << @arrays[1]
      @pool.available?.should be_false
    end
    
    it 'should delegate include? to the cache' do
      @pool.include?(@arrays[0]).should be_false
      @pool << @arrays[0]
      @pool.include?(@arrays[0]).should be_true
    end

    it 'can be emptied' do
      @pool << @arrays[0]
      @pool.size.should == 1
      @pool.empty!
      @pool.size.should == 0
    end
  end
  
  describe '#push' do
    it 'should push' do
      @pool.push(@arrays[0]) 
      @pool.push(@arrays[1])
      @pool.cache.first.should == @arrays[0]
    end
  
    it 'should call #clear on the object' do
      array = [1,2,3]
      array.should_receive(:clear)
      @pool.push array
    end
    
    it 'aliases #<< to push' do
      @pool << @arrays[0]
      @pool.cache.should == [@arrays[0]]
    end
    
    it 'should not grow larger than the max size' do  
      @pool << @arrays[0] 
      @pool << @arrays[1]
      @pool.size.should == 2 
      @pool << @arrays[2]
      @pool.size.should == 2
    end
  end
  
  
  describe 'get' do
    it 'should shift values from the top of the cache' do
      @pool << @arrays[0]  
      @pool << @arrays[1]
      @pool.size.should == 2
    
      value = @pool.shift
      value.should == @arrays[0]
    
      @pool.size.should == 1
    end
  
    it 'should have aliased methods #get' do 
      @pool << @arrays[0]
      @pool << @arrays[1] 
      @pool.get.should == @arrays[0]
      @pool.get.should == @arrays[1]
      @pool.size.should == 0
    end
  end
  
  
  describe 'stats' do
    it 'keeps track of get requests' do
      @pool << [1]
      @pool.get
      @pool.stats[:gets].should == 1
    end
    
    it 'does not log a get request when there when the cache is empty' do
      @pool.get
      @pool.stats[:gets].should == 0
    end
    
    it 'keeps track of push requests' do
      @pool << [1]
      @pool.stats[:pushes].should == 1
    end
    
    it 'keeps track of failed pushes' do
      @pool << [1]
      @pool << [2]
      @pool << [3]
      @pool.stats.should == {
        :gets => 0,
        :pushes => 2,
        :overage => 1
      }
    end
    
    it 'clears when empty' do
      @pool << [1]
      @pool.get
      @pool.stats.should_not == @empty_stats
      @pool.empty!
      @pool.stats.should == @empty_stats
    end
  end
end