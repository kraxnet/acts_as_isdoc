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

  def sender_details
    { :name => "Pepicek", :street=>"Ulicni", :building_number=>"230/9", :city => "Praha", :postal_code => "17000", :country_code=>"cz", :country=>"Czech Republic", :tax_number=>"CZ12345678" }
  end

  def customer_details
    { :name => "Frantisek" }
  end
end
