require File.dirname(__FILE__) + '/test_helper.rb'

class ActsAsIsdocTest < ActiveSupport::TestCase

  load_schema

  class SampleInvoice < ActiveRecord::Base
    acts_as_isdoc :document_type=>:invoice, :paid_deposits_amount => :paid_deposits

    def paid_deposits
      300
    end

    def sender_details
      { :name => "Pepicek", :street=>"Ulicni", :building_number=>"230/9", :city => "Praha", :postal_code => "17000", :country_code=>"cz", :country=>"Czech Republic", :tax_number=>"CZ12345678" }
    end

    def customer_details
      { :name => "Frantisek" }
    end
  end

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
    status = $?.exitstatus
    assert_equal "\n", File.read(diff_file)
  end

end
