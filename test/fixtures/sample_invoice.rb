class SampleInvoice < ActiveRecord::Base
  acts_as_isdoc :document_type=>"1",
    :paid_deposits_amount => :paid_deposits,
    :local_currency_code=>"CZK",
    :issue_date => :issued_on,
    :document_id => :id,
    :document_uuid => "UUID",
    :tax_point_date => "1970-01-01"

  def id
    123
  end

  def issued_on
    "2000-01-01"
  end

  def paid_deposits
    300
  end

  def seller_details
    { :name => "Pepicek", :street=>"Ulicni", :building_number=>"230/9", :city => "Praha", :postal_code => "17000", :country_code=>"cz", :country=>"Czech Republic", :tax_number=>"CZ12345678", :register_kept_at=>"Mestsky soud v Praze", :register_file_ref=>"C123456", :register_date=>"2001-01-01" }
  end

  def sender_details
    { :name => "Pepicek", :street=>"Ulicni", :building_number=>"230/9", :city => "Praha", :postal_code => "17000", :country_code=>"cz", :country=>"Czech Republic", :tax_number=>"CZ12345678" }
  end

  def customer_details
    { :name => "Frantisek" }
  end

  def recipient_details
    { :name => "Frantisek" }
  end

  def invoice_lines
    [
      {:line_extension_amount=>0, :line_extension_amount_tax_inclusive=>0, :line_extension_tax_amount=>0, :unit_price=>0, :unit_price_tax_inclusive=>0, :tax_percent=>19, :vat_calculation_method=>0, :description=>"First item"}
    ]
  end

  def tax_exclusive_amount
    0
  end

  def tax_inclusive_amount
    0
  end

  def already_claimed_tax_exclusive_amount
    0
  end

  def already_claimed_tax_inclusive_amount
    0
  end

  def difference_tax_exclusive_amount
    0
  end

  def difference_tax_inclusive_amount
    0
  end

  def payable_amount
    0
  end

  def tax_amount
    0
  end

  def tax_sub_totals
    [
      {:taxable_amount=>0, :tax_inclusive_amount=>0, :tax_amount => 0, :already_claimed_taxable_amount => 0, :already_claimed_tax_amount => 0, :already_claimed_tax_inclusive_amount => 0, :difference_taxable_amount => 0, :difference_tax_amount => 0, :difference_tax_inclusive_amount => 0, :tax_percent => 19 }
    ]
  end

end
