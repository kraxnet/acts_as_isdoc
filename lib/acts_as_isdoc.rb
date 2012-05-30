# -*- encoding : utf-8 -*-
module ActsAsIsdoc
  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods
    def acts_as_isdoc(options = {})
      cattr_accessor :document_type, :options
      self.document_type = options[:document_type]
      self.options = options
      send :include, InstanceMethods
    end
  end

  module InstanceMethods
    def render_isdoc
      ISDOCOutputBuilder.new(self, options).build
    end
  end
end

require 'builder'
module Builder
  class XmlBase
    def encoded_tag!(sym, *args, &block)
      args = args.map do |a|
        if a.kind_of? ::Hash
          a.each_pair {|key, value| a[key] = ::HTMLEntities.new.encode(value)}
        else
          ::HTMLEntities.new.encode(a)
        end
      end
      tag!(sym, *args, &block)
    end
  end
end

ActiveRecord::Base.send :include, ActsAsIsdoc
