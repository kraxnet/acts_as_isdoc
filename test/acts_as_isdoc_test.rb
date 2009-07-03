require File.dirname(__FILE__) + '/test_helper.rb'
require File.dirname(__FILE__) + '/fixtures/sample_invoice.rb'

class ActsAsIsdocTest < ActiveSupport::TestCase

  load_schema

  test "responds_to render_isdoc" do
    assert SampleInvoice.new.respond_to?(:render_isdoc)
  end

  test "returned isdoc is valid" do
    assert valid_isdoc?(SampleInvoice.new.render_isdoc)
  end

  test "returned isdoc is correct" do
    isdoc_file = create_tmp_file("isdoc", SampleInvoice.new.render_isdoc)
    fixture_file = File.join(File.dirname(__FILE__), "..", "test", "fixtures", "sample_invoice.isdoc")
    diff_file = create_tmp_file("diff_file")
    command = "diff #{isdoc_file} #{fixture_file} >> #{diff_file}"
    system(command)
    assert_equal "\n", File.read(diff_file)
  end

end
