class ISDOCOutputBuilder
  def initialize(object)
  end

  def build
    isdoc = Builder::XmlMarkup.new :indent => 4
    isdoc.instruct! :xml

    isdoc.tag!( :Invoice, :xmlns=>"http://isdoc.cz/namespace/invoice", :version=>"5.1") do |invoice|
      invoice.tag! :DocumentType, 1
      invoice.tag! :ID
      invoice.tag! :UUID

      invoice.tag! :IssueDate, Date.today.to_s(:db)

      invoice.tag! :LocalCurrencyCode, "XYZ"
      invoice.tag! :CurrRate, 1
      invoice.tag! :RefCurrRate, 1

      invoice.tag! :AccountingSupplierParty do |supplier|
        build_party supplier
      end

      invoice.tag! :AccountingCustomerParty do |customer|
        build_party customer
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
        legal_monetary_total.tag! :PaidDepositsAmount, 0
        legal_monetary_total.tag! :PayableAmount, 0
      end
    end
    isdoc.target!
  end

  def build_party(xml)
    xml.tag! :Party do |party|
      party.tag! :PartyIdentification do |party_identification|
        party_identification.tag! :UserID
        party_identification.tag! :CatalogFirmIdentification
        party_identification.tag! :ID
      end
      party.tag! :PartyName do |party_name|
        party_name.tag! :Name , ""
      end
      party.tag! :PostalAddress do |postal_address|
        postal_address.tag! :StreetName, ""
        postal_address.tag! :BuildingNumber, ""
        postal_address.tag! :CityName, ""
        postal_address.tag! :PostalZone, ""
        postal_address.tag! :Country do |country|
          country.tag! :IdentificationCode, ""
          country.tag! :Name, ""
        end
      end
    end
  end

end