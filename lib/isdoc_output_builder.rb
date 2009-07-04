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
      invoice.tag! :DocumentType, document_type
      invoice.tag! :ID, document_id
      invoice.tag! :UUID, document_uuid

      invoice.tag! :IssueDate, issue_date
      invoice.tag! :TaxPointDate, tax_point_date if tax_point_date

      invoice.tag! :LocalCurrencyCode, local_currency_code
      invoice.tag! :CurrRate, 1
      invoice.tag! :RefCurrRate, 1

      invoice.tag! :AccountingSupplierParty do |supplier|
        build_party supplier, seller_details
      end

      invoice.tag! :SellerSupplierParty do |sender|
        build_party sender, sender_details
      end if sender_details

      invoice.tag! :AccountingCustomerParty do |customer|
        build_party customer, customer_details
      end

      invoice.tag! :BuyerCustomerParty do |recipient|
        build_party recipient, recipient_details
      end if recipient_details

      invoice.tag! :InvoiceLines do |invoice_lines_tag|
        build_invoice_lines invoice_lines_tag, invoice_lines
      end

      invoice.tag! :TaxTotal do |tax_total|
        build_tax_sub_totals(tax_total, tax_sub_totals)
        tax_total.tag! :TaxAmount, tax_amount
      end

      invoice.tag! :LegalMonetaryTotal do |legal_monetary_total|
        legal_monetary_total.tag! :TaxExclusiveAmount, tax_exclusive_amount
        legal_monetary_total.tag! :TaxInclusiveAmount, tax_inclusive_amount
        legal_monetary_total.tag! :AlreadyClaimedTaxExclusiveAmount, already_claimed_tax_exclusive_amount
        legal_monetary_total.tag! :AlreadyClaimedTaxInclusiveAmount, already_claimed_tax_inclusive_amount
        legal_monetary_total.tag! :DifferenceTaxExclusiveAmount, difference_tax_exclusive_amount
        legal_monetary_total.tag! :DifferenceTaxInclusiveAmount, difference_tax_inclusive_amount
        legal_monetary_total.tag! :PaidDepositsAmount, paid_deposits_amount
        legal_monetary_total.tag! :PayableAmount, payable_amount
      end

      invoice.tag! :PaymentMeans do |payment_means|
        payment_means.tag! :Payment do |payment|
          payment.tag! :PaidAmount, payment_means_detail[:paid_amount]
          payment.tag! :PaymentMeansCode, payment_means_detail[:payments_mean_code]
          payment.tag! :Details do |details|
            build_bank_account(details, payment_means_detail)
          end #if payment_means_detail[:payments_mean_code.to_i==42]
        end
        payment_means.tag! :AlternateBankAccounts do |alternate_bank_accounts|
          for alternate_bank_account in payment_means_detail[:alternate_bank_accounts]
            alternate_bank_accounts.tag! :AlternateBankAccount do
              build_bank_account(alternate_bank_accounts, alternate_bank_account)
            end
          end
        end if payment_means_detail[:alternate_bank_accounts]
      end if payment_means_detail
    end
    isdoc.target!
  end

  def build_party(xml, details)
    details = details.symbolize_keys
    xml.tag! :Party do |party|
      party.tag! :PartyIdentification do |party_identification|
        party_identification.tag! :UserID
        party_identification.tag! :CatalogFirmIdentification
        party_identification.tag! :ID, details[:company_id]
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
      party.tag! :RegisterIdentification do |register_identification|
        register_identification.tag! :RegisterKeptAt, details[:register_kept_at]
        register_identification.tag! :RegisterFileRef, details[:register_file_ref]
        register_identification.tag! :RegisterDate, details[:register_date]
      end if details[:register_kept_at]
    end
  end

  def build_invoice_lines(invoice_lines, items)
    items.each_with_index do |item, index|
      invoice_lines.tag! :InvoiceLine do |invoice_line|
        invoice_line.tag! :ID, index+1
        invoice_line.tag! :LineExtensionAmount, item[:line_extension_amount]
        invoice_line.tag! :LineExtensionAmountTaxInclusive, item[:line_extension_amount_tax_inclusive]
        invoice_line.tag! :LineExtensionTaxAmount, item[:line_extension_tax_amount]
        invoice_line.tag! :UnitPrice, item[:unit_price]
        invoice_line.tag! :UnitPriceTaxInclusive, item[:unit_price_tax_inclusive]
        invoice_line.tag! :ClassifiedTaxCategory do |classified_tax_category|
          classified_tax_category.tag! :Percent, item[:tax_percent]
          classified_tax_category.tag! :VATCalculationMethod, item[:vat_calculation_method]
        end
        invoice_line.tag! :Item do |item_tag|
          item_tag.tag! :Description, item[:description] if item[:description]
        end
        draw_invoice_line_extensions(invoice_line, item) if ledger_item.respond_to?(:draw_invoice_line_extensions)
      end
    end
  end

  def build_tax_sub_totals(tax_total, tax_sub_totals)
    for tax_sub_total in tax_sub_totals
      tax_total.tag! :TaxSubTotal do |tax_sub_total_tag|
        tax_sub_total_tag.tag! :TaxableAmount, tax_sub_total[:taxable_amount]
        tax_sub_total_tag.tag! :TaxInclusiveAmount, tax_sub_total[:tax_inclusive_amount]
        tax_sub_total_tag.tag! :TaxAmount, tax_sub_total[:tax_amount]
        tax_sub_total_tag.tag! :AlreadyClaimedTaxableAmount, tax_sub_total[:already_claimed_taxable_amount]
        tax_sub_total_tag.tag! :AlreadyClaimedTaxAmount, tax_sub_total[:already_claimed_tax_amount]
        tax_sub_total_tag.tag! :AlreadyClaimedTaxInclusiveAmount, tax_sub_total[:already_claimed_tax_inclusive_amount]
        tax_sub_total_tag.tag! :DifferenceTaxableAmount, tax_sub_total[:difference_taxable_amount]
        tax_sub_total_tag.tag! :DifferenceTaxAmount, tax_sub_total[:difference_tax_amount]
        tax_sub_total_tag.tag! :DifferenceTaxInclusiveAmount, tax_sub_total[:difference_tax_inclusive_amount]
        tax_sub_total_tag.tag! :TaxCategory do |tax_category|
          tax_category.tag! :Percent, tax_sub_total[:tax_percent]
        end
      end
    end
  end

  def build_bank_account(xml, details)
    xml.tag! :PaymentDueDate, details[:payment_due_date] if details[:payment_due_date]
    xml.tag! :ID, details[:id]
    xml.tag! :BankCode, details[:bank_code]
    xml.tag! :Name, details[:name]
    xml.tag! :IBAN, details[:iban]
    xml.tag! :BIC, details[:bic]
    # xml.tag! :VariableSymbol, payment_means[:variable_symbol]
  end

  def method_missing(method_id, *args, &block)
    # method renaming if requested in options
    if options.has_key?(method_id.to_sym)
      method_id = options[method_id.to_sym]
      # allows setting default values directly instead of calling a method
      return method_id unless ledger_item.respond_to?(method_id)
    end
    return ledger_item.send(method_id, *args) if ledger_item.respond_to?(method_id)
  end

end