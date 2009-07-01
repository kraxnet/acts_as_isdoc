require File.dirname(__FILE__) + '/test_helper.rb'

class ActsAsIsdocTest < ActiveSupport::TestCase

  load_schema

  class SampleInvoice < ActiveRecord::Base
    acts_as_isdoc
  end

  test "responds_to_render_isdoc" do
    assert SampleInvoice.new.respond_to?(:render_isdoc)
  end

end
