require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe RuPol do
  class Irreplacable 
    include RuPol::Swimsuit
    
    def initialize(opts={})
      @foo = opts[:foo] || 'bar'
    end
    
    def foo
      @foo = "foo"
    end
  end
  
  class Replacing < Array
    include RuPol
  end
  
  describe 'class level pool' do
    it 'adds a _pool to the class' do
      Irreplacable._pool.class.should == RuPol::Pool
    end
    
    it 'sets the default size to 1000' do
      Irreplacable._pool.max_size.should == 1000
    end
    
    it 'sets the default size to the size of it superclass if it has one' do
      class BigPool
        include RuPol::Swimsuit
        max_pool_size 10000
      end
      
      BigPool._pool.max_size.should == 10000
      
      class BigPoolDescendant < BigPool; end
      
      BigPoolDescendant._pool.max_size.should == 10000
    end
    
    it 'pool max size is settable via the #max_pool_size class method' do
      Irreplacable.max_pool_size 42
      Irreplacable._pool.max_size.should == 42
    end
    
    it 'has a method for clearing' do
      Irreplacable._pool << Irreplacable.new
      Irreplacable._pool.size.should == 1
      Irreplacable.empty_pool!
      Irreplacable._pool.size.should == 0
    end
  end
  
  describe '#recycle' do
    before :all do
      @instance = Irreplacable.new
      @replacable_instance = Replacing.new
      
      @instance._recycled.should be_false
      @replacable_instance._recycled.should be_false
      
      @instance.recycle
      @replacable_instance.recycle
    end
    
    it 'adds it to the pool' do
      Irreplacable._pool.should include @instance
      Replacing._pool.should include @replacable_instance
    end
    
    it 'sets the _recycled flag to true' do
      @instance._recycled.should be_true
      @replacable_instance._recycled.should be_true
    end
  end
  
  describe '#rehydrate' do
    before :all do
      Irreplacable.empty_pool!
      Replacing.empty_pool!
      
      @instance = Irreplacable.new
      @replacable_instance = Replacing.new
      
      @instance.recycle
      @replacable_instance.recycle
      
      @new_instance = Irreplacable.rehydrate(:foo => 'foof')
    end
    
    it 'should remove the instance from the cache' do
      Irreplacable._pool.should_not include(@instance)
    end
    
    it 'should set the _recycled flag to false' do
      @instance._recycled.should be_false
    end
    
    it 'should initialize the instance with the passed in options' do
      @new_instance.instance_variable_get('@foo').should == 'foof'
    end
    
    it 'works with an initialize method that takes no aruments' do
      Replacing.rehydrate
      Replacing._pool.should_not include(@replacable_instance)
      @replacable_instance._recycled.should be_false
    end
    
    it 'replaces content in a replacable object' do
      @replacable_instance.recycle
      
      instance = Replacing.rehydrate(['foo', 'bar'])
      instance.should == ['foo', 'bar']
    end
    
    it 'returns nil if there is nothing in the cache' do
      Replacing.empty_pool!
      Replacing.rehydrate(['bar']).should == nil
    end
    
    it 'should return the instance' do
      @new_instance.should === @instance
    end
  end
  
  
  describe RuPol::Swimsuit do
    describe '#clear' do
      it 'calls super' do
        instance = Replacing.new
        instance.clear
        instance.should be_empty
      end
    
      it 'does not freak on super if ther is no superclass' do
        instance = Irreplacable.new
        instance.clear
      end
    
      it 'clears instance variables' do
        instance = Irreplacable.new
        instance.foo
        instance.instance_variable_get('@foo').should == "foo"
      
        instance.clear
        instance.instance_variable_get('@foo').should == nil
      end
    
      it 'returns self for chaining' do
        instance = Replacing.new
        instance.clear.should === instance
      end
    end
    
    describe 'overwriting new' do
      before do
        Irreplacable.empty_pool!
      end
      
      it 'will return a brand new instance if the pool is empty' do
        Irreplacable._pool.size.should == 0
        instance = Irreplacable.new
        instance.class.should == Irreplacable
      end
      
      it 'rehydrate if there are instances in the pool' do
        instance = Irreplacable.new
        instance.recycle
        
        Irreplacable.new.should === instance
      end
    end
    
    describe 'destroy' do
      class Destroyable
        def self.destroyed
          @destroyed ||= false
        end
        
        def self.destroyed=(value)
          @destroyed = value
        end
         
        def destroy
          self.class.destroyed = true
        end
      end

      class DestroyableDescendant < Destroyable
        include RuPol::Swimsuit
      end
      
      before do
        DestroyableDescendant.destroyed = false
        DestroyableDescendant.empty_pool!
        Irreplacable.empty_pool!
        @instance = DestroyableDescendant.new
      end
      
      it 'calls super' do
        @instance.destroy
        DestroyableDescendant.destroyed.should == true
      end
      
      it 'recycles the instance' do
        @instance.destroy
        DestroyableDescendant._pool.should include @instance
      end
      
      it 'does not fail if there is no #destroy method in the ancestor chain' do
        instance = Irreplacable.new
        instance.destroy
        Irreplacable._pool.should include instance
      end
    end
  
    describe 'new' do
      class Inity1 
        include RuPol::Swimsuit
        
        attr_accessor :arg_1
        
        def initialize(arg_1)
          self.arg_1 = arg_1
        end
      end
      
      class Inity2 < Inity1
        include RuPol::Swimsuit
        attr_accessor :arg_2
        
        def initialize(arg_1, arg_2)
          super(arg_1)
          self.arg_2 = arg_2
        end
      end
      
      before do
        Irreplacable.empty_pool!
        Inity1.empty_pool!
        Inity2.empty_pool!
      end
      
      describe 'pass thru to init' do
        it 'works when there are no arguments' do
          Irreplacable.new
        end
        
        it 'works with one argument' do
          Inity1.new(:foo).arg_1.should == :foo
        end
        
        it 'works with many arguments' do
          i = Inity2.new(:bar, :foo)
          i.arg_1.should == :bar
          i.arg_2.should == :foo
        end
      end
      
      describe 'blocks' do
        class Blocky
          attr_accessor :has_block
          include RuPol::Swimsuit
          def initialize(&block)
            self.has_block = block_given?
          end
        end
        
        before do
          Blocky.empty_pool!
        end
        
        it 'passes the block along on a brand new object' do
          blocky = Blocky.new { "oh yes, it is!" }
          blocky.has_block.should be_true
        end
        
        it 'passes the block to recycled items on reinit' do
          blocky = Blocky.new { "first run" }
          blocky.has_block.should be_true
          blocky.recycle
          blocky.has_block.should be_nil
          
          new_blocky = Blocky.new { "and again" }
          new_blocky.has_block.should be_true
        end
      end
      
      describe 'rehydrating' do
        before do
          [
            @irr = Irreplacable.new,
            @init1 = Inity1.new(:foo),
            @init2 = Inity2.new(:bar, :foo)
          ].map{|i| i.destroy }
          Irreplacable._pool.size.should == 1
          Inity1._pool.size.should == 1
          Inity2._pool.size.should == 1
        end
        
        it 'works when there are no arguments' do
          Irreplacable.new
        end
        
        it 'works with one argument' do
          Inity1.new(:foo).arg_1.should == :foo
        end
        
        it 'works with many arguments' do
          i = Inity2.new(:bar, :foo)
          i.arg_1.should == :bar
          i.arg_2.should == :foo
        end
      end
    end
  end
end