require File.dirname(__FILE__) + '/test_helper.rb'

class ActsAsIsdocTest < ActiveSupport::TestCase

  load_schema

  class SampleInvoice < ActiveRecord::Base
    acts_as_isdoc :document_type=>:invoice
  end

  test "responds_to render_isdoc" do
    assert SampleInvoice.new.respond_to?(:render_isdoc)
  end

  test "render_isdoc returns isdoc" do
    assert_equal "XML", SampleInvoice.new.render_isdoc
  end

end
