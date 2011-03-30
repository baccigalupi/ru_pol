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
      @pool ||= Pool.new(1000, self)
    end
    
    def max_pool_size(max_size)
      _pool.max_size = max_size
    end
    
    def empty_pool!
      _pool.empty!
    end
    
    def rehydrate(*init_opts)
      instance = _pool.get
      if instance
        instance.instance_eval { init_opts.empty? ? initialize : initialize(*init_opts) }
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
      def new(*init_opts)
        rehydrate(*init_opts) || ( init_opts.empty? ? super() : super(*init_opts) )
      end
    end
  end
end