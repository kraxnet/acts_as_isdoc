class ISDOCOutputBuilder

  attr_reader :ledger_item, :options

  def initialize(ledger_item, options)
    @ledger_item = ledger_item
    @options = options
  end

  def build
    isdoc = Builder::XmlMarkup.new :indent => 4
    isdoc.instruct! :xml

    isdoc.tag!( :Invoice, :xmlns=>"http://isdoc.cz/namespace/invoice", :version=>"5.1") do |invoice|
      invoice.tag! :DocumentType, 1
      invoice.tag! :ID
      invoice.tag! :UUID

      invoice.tag! :IssueDate, Date.today.to_s(:db)

      invoice.tag! :LocalCurrencyCode, local_currency_code
      invoice.tag! :CurrRate, 1
      invoice.tag! :RefCurrRate, 1

      invoice.tag! :AccountingSupplierParty do |supplier|
        build_party supplier, sender_details
      end

      invoice.tag! :AccountingCustomerParty do |customer|
        build_party customer, customer_details
      end

      invoice.tag! :InvoiceLines do |invoice_lines|
        invoice_lines.tag! :InvoiceLine do |invoice_line|
          invoice_line.tag! :ID
          invoice_line.tag! :LineExtensionAmount, 0
          invoice_line.tag! :LineExtensionAmountTaxInclusive, 0
          invoice_line.tag! :LineExtensionTaxAmount, 0
          invoice_line.tag! :UnitPrice, 0
          invoice_line.tag! :UnitPriceTaxInclusive, 0
          invoice_line.tag! :ClassifiedTaxCategory do |classified_tax_category|
            classified_tax_category.tag! :Percent, 0
            classified_tax_category.tag! :VATCalculationMethod, 0
          end
          invoice_line.tag! :Item
        end
      end

      invoice.tag! :TaxTotal do |tax_total|
        tax_total.tag! :TaxSubTotal do |tax_sub_total|
          tax_sub_total.tag! :TaxableAmount, 0
          tax_sub_total.tag! :TaxInclusiveAmount, 0
          tax_sub_total.tag! :TaxAmount, 0
          tax_sub_total.tag! :AlreadyClaimedTaxableAmount, 0
          tax_sub_total.tag! :AlreadyClaimedTaxAmount, 0
          tax_sub_total.tag! :AlreadyClaimedTaxInclusiveAmount, 0
          tax_sub_total.tag! :DifferenceTaxableAmount, 0
          tax_sub_total.tag! :DifferenceTaxAmount, 0
          tax_sub_total.tag! :DifferenceTaxInclusiveAmount, 0
          tax_sub_total.tag! :TaxCategory do |tax_category|
            tax_category.tag! :Percent, 0
          end
        end
        tax_total.tag! :TaxAmount, 0
      end

      invoice.tag! :LegalMonetaryTotal do |legal_monetary_total|
        legal_monetary_total.tag! :TaxExclusiveAmount, 0
        legal_monetary_total.tag! :TaxInclusiveAmount, 0
        legal_monetary_total.tag! :AlreadyClaimedTaxExclusiveAmount, 0
        legal_monetary_total.tag! :AlreadyClaimedTaxInclusiveAmount, 0
        legal_monetary_total.tag! :DifferenceTaxExclusiveAmount, 0
        legal_monetary_total.tag! :DifferenceTaxInclusiveAmount, 0
        legal_monetary_total.tag! :PaidDepositsAmount, paid_deposits_amount
        legal_monetary_total.tag! :PayableAmount, 0
      end
    end
    isdoc.target!
  end

  def build_party(xml, details)
    details = details.symbolize_keys
    xml.tag! :Party do |party|
      party.tag! :PartyIdentification do |party_identification|
        party_identification.tag! :UserID
        party_identification.tag! :CatalogFirmIdentification
        party_identification.tag! :ID
      end
      party.tag! :PartyName do |party_name|
        party_name.tag! :Name, details[:name]
      end
      party.tag! :PostalAddress do |postal_address|
        postal_address.tag! :StreetName, details[:street]
        postal_address.tag! :BuildingNumber, details[:building_number]
        postal_address.tag! :CityName, details[:city]
        postal_address.tag! :PostalZone, details[:postal_code]
        postal_address.tag! :Country do |country|
          country.tag! :IdentificationCode, details[:country_code]
          country.tag! :Name, details[:country]
        end
      end
      party.tag! :PartyTaxScheme do |party_tax_scheme|
        party_tax_scheme.tag! :CompanyID, details[:tax_number]
        party_tax_scheme.tag! :TaxScheme, "VAT"
      end if details[:tax_number]
    end
  end

  def method_missing(method_id, *args, &block)
    # method renaming if requested in options
    if options.has_key?(method_id.to_sym)
      method_id = options[method_id.to_sym]
      # allows setting default values directly instead of calling a method
      return method_id unless ledger_item.respond_to?(method_id)
    end
    ledger_item.send(method_id)
  end

end