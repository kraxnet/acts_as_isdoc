require File.dirname(__FILE__) + '/test_helper.rb'

class ActsAsIsdocTest < ActiveSupport::TestCase

  load_schema

  class SampleInvoice < ActiveRecord::Base
    acts_as_isdoc :document_type=>:invoice
  end

  test "responds_to render_isdoc" do
    assert SampleInvoice.new.respond_to?(:render_isdoc)
  end

  test "returned isdoc is valid" do
    assert valid_isdoc?(SampleInvoice.new.render_isdoc)
  end

end
