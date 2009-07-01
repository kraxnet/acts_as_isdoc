module ActsAsIsdoc
  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods
    def acts_as_isdoc
      send :include, InstanceMethods
    end
  end

  module InstanceMethods
    def render_isdoc
    end
  end
end

ActiveRecord::Base.send :include, ActsAsIsdoc