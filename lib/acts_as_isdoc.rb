module ActsAsIsdoc
  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods
    def acts_as_isdoc(options = {})
      cattr_accessor :document_type
      self.document_type = options[:document_type]
      send :include, InstanceMethods
    end
  end

  module InstanceMethods
    def render_isdoc
    end
  end
end

ActiveRecord::Base.send :include, ActsAsIsdoc