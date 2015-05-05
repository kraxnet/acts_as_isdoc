# -*- encoding : utf-8 -*-
require 'active_record'
require 'acts_as_isdoc'
class SampleInvoice < ActiveRecord::Base
  acts_as_isdoc :document_type=>"1",
    :paid_deposits_amount => :paid_deposits,
    :local_currency_code=>"CZK",
    :issue_date => :issued_on,
    :document_id => :id,
    :document_uuid => "2D6D6400-D922-4DF5-8A76-EB68350B02AF",
    :tax_point_date => "1970-01-01",
    :note => "Poznamka",
    :vat_applicable => "true"

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
    { :company_id=>"12345678", :name => "Pepicek", :street=>"Ulicni", :building_number=>"230/9", :city => "Praha", :postal_code => "17000", :country_code=>"cz", :country=>"Czech Republic", :tax_number=>"CZ12345678", :register_kept_at=>"Mestsky soud v Praze", :register_file_ref=>"C123456", :register_date=>"2001-01-01" }
  end

  def sender_details
    { :name => "Pepicek", :street=>"Ulicni", :building_number=>"230/9", :city => "Praha", :postal_code => "17000", :country_code=>"cz", :country=>"Czech Republic", :tax_number=>"CZ12345678" }
  end

  def customer_details
    { :name => "Frantisek", :user_id=>"54321" }
  end

  def recipient_details
    { :name => "Frantisek" }
  end

  def invoice_lines
    [
      {:line_extension_amount=>0, :line_extension_amount_tax_inclusive=>0, :line_extension_tax_amount=>0, :unit_price=>0, :unit_price_tax_inclusive=>0, :tax_percent=>19, :vat_calculation_method=>0, :description=>"First item", :sellers_item_identification => "ABC-123", }
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

  def payment_means_detail
    {:paid_amount=>100, :payments_mean_code=>42, :bank_code=>5500, :payment_due_date=>"2006-01-01",
      :variable_symbol=>"12345678",
      :alternate_bank_accounts=>[{:bank_code=>0300}]
    }
  end

  def non_taxed_deposits
    [
      {:id=>"1234", :variable_symbol=>"1234", :deposit_amount=>300}
    ]
  end

  def taxed_deposits
    [
      {:id=>"1234", :variable_symbol=>"1234", :taxable_deposit_amount=>100, :tax_inclusive_deposit_amount=>119, :tax_percent=>19, :vat_calculation_method=>0 }
    ]
  end

end
