class SampleInvoice < ActiveRecord::Base
  acts_as_isdoc :document_type=>:invoice,
    :paid_deposits_amount => :paid_deposits,
    :local_currency_code=>"CZK"

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
