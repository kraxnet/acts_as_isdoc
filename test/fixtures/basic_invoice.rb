class BasicInvoice < ActiveRecord::Base
  acts_as_isdoc :document_type=>"1",
    :paid_deposits_amount => "300",
    :local_currency_code=>"CZK",
    :issue_date => "2009-07-01",
    :tax_amount => "0",
    :tax_exclusive_amount => "0",
    :tax_inclusive_amount => "0",
    :already_claimed_tax_exclusive_amount => "0",
    :already_claimed_tax_inclusive_amount => "0",
    :difference_tax_exclusive_amount => "0",
    :difference_tax_inclusive_amount => "0",
    :payable_amount => "0",
    :document_id => "1234"

  def id
    1
  end

  def sender_details
    { :name => "Pepicek", :street=>"Ulicni", :building_number=>"230/9", :city => "Praha", :postal_code => "17000", :country_code=>"cz", :country=>"Czech Republic", :tax_number=>"CZ12345678" }
  end

  def customer_details
    { :name => "Frantisek" }
  end
  
  def invoice_lines
    [ {:line_extension_amount=>0, :line_extension_amount_tax_inclusive=>0, :line_extension_tax_amount=>0, :unit_price=>0, :unit_price_tax_inclusive=>0, :tax_percent=>0, :vat_calculation_method=>0} ]
  end

  def tax_sub_totals
    [ {:taxable_amount=>0, :tax_inclusive_amount=>0, :tax_amount => 0, :already_claimed_taxable_amount => 0, :already_claimed_tax_amount => 0, :already_claimed_tax_inclusive_amount => 0, :difference_taxable_amount => 0, :difference_tax_amount => 0, :difference_tax_inclusive_amount => 0, :tax_percent => 0 } ]
  end
end
