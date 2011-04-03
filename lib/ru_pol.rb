require File.dirname(__FILE__) + '/pool'

# module for inclusion
module RuPol
  def self.included(base_class)
    base_class.class_eval do
      include InstanceMethods
      extend ClassMethods
      
      attr_accessor :_recycled
    end
  end
  
  module ClassMethods
    def _pool
      @pool ||= Pool.new(default_pool_size, self)
    end
    
    def default_pool_size
      superclass.respond_to?(:_pool) ? superclass._pool.max_size : 1000
    end
    
    def max_pool_size(max_size)
      _pool.max_size = max_size
    end
    
    def empty_pool!
      _pool.empty!
    end
    
    def rehydrate(*init_opts, &block)
      instance = _pool.get
      if instance
        instance.instance_eval { init_opts.empty? ? initialize(&block) : initialize(*init_opts, &block) }
      end
      instance
    end
  end
  
  module InstanceMethods
    def recycle
      _pool << self
      self
    end
    
    def _pool
      self.class._pool
    end
  end
  
  module Swimsuit
    def self.included(base_class)
      base_class.class_eval do
        include ::RuPol
        include InstanceMethods
        extend ClassMethods
      end
    end
    
    module InstanceMethods
      def clear
        super rescue nil
        instance_variables.each do |var|
          instance_variable_set(var, nil) unless var == "@_recycled"
        end
        self
      end
      
      def destroy
        super rescue nil
        recycle
      end
    end
    
    module ClassMethods
      def new(*init_opts, &block)
        rehydrate(*init_opts, &block) || ( init_opts.empty? ? super() : super(*init_opts) )
      end
    end
  end
end