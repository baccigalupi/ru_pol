module RuPol
  class Pool
    attr_accessor :max_size, :cache, :stats, :instance_class, 
      :recycledable, :clearable
    
    def initialize(max, klass)
      self.max_size = max
      self.instance_class = klass
      self.cache = []
      self.stats = empty_stats
      self.recycledable = class_has_method?(:_recycled)
      self.clearable = class_has_method?(:clear)
    end
    
    def class_has_method?(meth)
      instance_class.instance_methods.include?(meth.to_s)
    end
    
    def empty_stats
      {
        :gets => 0,
        :pushes => 0,
        :overage => 0
      }
    end
    
    def size
      cache.size
    end
    
    def push(value)
      if available?
        stats[:pushes] += 1 
        value.clear if clearable
        value._recycled = true if recycledable
        cache.push( value )
      else
        stats[:overage] += 1
      end
      value 
    end
    
    def available?
      size < max_size
    end
    
    def include?(value)
      cache.include?(value)
    end
    
    def shift
      instance = cache.shift
      if instance
        stats[:gets] += 1
        instance._recycled = false if instance.respond_to?(:_recycled)
        instance
      end
    end
    
    def empty!
      self.stats = empty_stats
      cache.clear
    end
    
    alias :<< :push
    alias :get :shift
  end
end