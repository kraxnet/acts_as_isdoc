# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/test_helper.rb'
require File.dirname(__FILE__) + '/fixtures/sample_invoice.rb'
require File.dirname(__FILE__) + '/fixtures/basic_invoice.rb'
require File.dirname(__FILE__) + '/fixtures/extended_invoice.rb'

class ActsAsIsdocTest < ActiveSupport::TestCase

  load_schema

  test "responds_to render_isdoc" do
    assert BasicInvoice.new.respond_to?(:render_isdoc)
  end

  test "returned basic isdoc is valid" do
    assert valid_isdoc?(BasicInvoice.new.render_isdoc)
  end

  test "returned basic isdoc is correct" do
    isdoc_file = create_tmp_file("isdoc", BasicInvoice.new.render_isdoc)
    fixture_file = File.join(File.dirname(__FILE__), "..", "test", "fixtures", "basic_invoice.isdoc")
    assert_file_equals(isdoc_file, fixture_file)
  end

  test "returned sample isdoc is valid" do
    assert valid_isdoc?(SampleInvoice.new.render_isdoc)
  end

  test "returned sample isdoc is correct" do
    isdoc_file = create_tmp_file("isdoc", SampleInvoice.new.render_isdoc)
    fixture_file = File.join(File.dirname(__FILE__), "..", "test", "fixtures", "sample_invoice.isdoc")
    assert_file_equals(isdoc_file, fixture_file)
  end

  test "returned extended isdoc is valid" do
    assert valid_isdoc?(ExtendedInvoice.new.render_isdoc)
  end

  test "returned extended isdoc is correct" do
    isdoc_file = create_tmp_file("isdoc", ExtendedInvoice.new.render_isdoc)
    fixture_file = File.join(File.dirname(__FILE__), "..", "test", "fixtures", "extended_invoice.isdoc")
    assert_file_equals(isdoc_file, fixture_file)
  end

end
