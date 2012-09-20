# -*- encoding : utf-8 -*-
class ISDOCOutputBuilder

  attr_reader :ledger_item, :options

  def initialize(ledger_item, options)
    @ledger_item = ledger_item
    @options = options
  end

  def build
    isdoc = Builder::XmlMarkup.new :indent => 4
    isdoc.instruct! :xml

    isdoc.encoded_tag!( :Invoice, :xmlns=>"http://isdoc.cz/namespace/invoice", :version=>"5.2") do |invoice|
      invoice.encoded_tag! :DocumentType, document_type
      invoice.encoded_tag! :ID, document_id
      invoice.encoded_tag! :UUID, document_uuid

      invoice.encoded_tag! :IssueDate, issue_date
      invoice.encoded_tag! :TaxPointDate, tax_point_date if tax_point_date

      invoice.encoded_tag! :Note, note if note

      invoice.encoded_tag! :OrderReferences do |order_references|
        order_references.encoded_tag! :OrderReference do |order_reference|
          order_reference.encoded_tag! :SalesOrderID
          order_reference.encoded_tag! :ExternalOrderID, external_order_id
          order_reference.encoded_tag! :IssueDate, issue_date
        end
      end if external_order_id

      invoice.encoded_tag! :LocalCurrencyCode, local_currency_code
      invoice.encoded_tag! :CurrRate, 1
      invoice.encoded_tag! :RefCurrRate, 1

      draw_dispatches(invoice, dispatches)

      invoice.encoded_tag! :AccountingSupplierParty do |supplier|
        build_party supplier, seller_details
      end

      invoice.encoded_tag! :SellerSupplierParty do |sender|
        build_party sender, sender_details
      end if sender_details

      invoice.encoded_tag! :AccountingCustomerParty do |customer|
        build_party customer, customer_details
      end

      invoice.encoded_tag! :BuyerCustomerParty do |recipient|
        build_party recipient, recipient_details
      end if recipient_details

      invoice.encoded_tag! :InvoiceLines do |invoice_lines_tag|
        build_invoice_lines invoice_lines_tag, invoice_lines
      end

      invoice.encoded_tag! :NonTaxedDeposits do |non_taxed_deposits_tag|
        build_non_taxed_deposits non_taxed_deposits_tag, non_taxed_deposits
      end if non_taxed_deposits

      invoice.encoded_tag! :TaxedDeposits do |taxed_deposits_tag|
        build_taxed_deposits taxed_deposits_tag, taxed_deposits
      end if taxed_deposits

      invoice.encoded_tag! :TaxTotal do |tax_total|
        build_tax_sub_totals(tax_total, tax_sub_totals)
        tax_total.encoded_tag! :TaxAmount, tax_amount
      end

      invoice.encoded_tag! :LegalMonetaryTotal do |legal_monetary_total|
        legal_monetary_total.encoded_tag! :TaxExclusiveAmount, tax_exclusive_amount
        legal_monetary_total.encoded_tag! :TaxInclusiveAmount, tax_inclusive_amount
        legal_monetary_total.encoded_tag! :AlreadyClaimedTaxExclusiveAmount, already_claimed_tax_exclusive_amount
        legal_monetary_total.encoded_tag! :AlreadyClaimedTaxInclusiveAmount, already_claimed_tax_inclusive_amount
        legal_monetary_total.encoded_tag! :DifferenceTaxExclusiveAmount, difference_tax_exclusive_amount
        legal_monetary_total.encoded_tag! :DifferenceTaxInclusiveAmount, difference_tax_inclusive_amount
        legal_monetary_total.encoded_tag! :PaidDepositsAmount, paid_deposits_amount
        legal_monetary_total.encoded_tag! :PayableAmount, payable_amount
      end

      invoice.encoded_tag! :PaymentMeans do |payment_means|
        payment_means.encoded_tag! :Payment do |payment|
          payment.encoded_tag! :PaidAmount, payment_means_detail[:paid_amount]
          payment.encoded_tag! :PaymentMeansCode, payment_means_detail[:payments_mean_code]
          payment.encoded_tag! :Details do |details|
            build_bank_account(details, payment_means_detail, true)
          end #if payment_means_detail[:payments_mean_code.to_i==42]
        end
        payment_means.encoded_tag! :AlternateBankAccounts do |alternate_bank_accounts|
          for alternate_bank_account in payment_means_detail[:alternate_bank_accounts]
            alternate_bank_accounts.encoded_tag! :AlternateBankAccount do
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
    xml.encoded_tag! :Party do |party|
      party.encoded_tag! :PartyIdentification do |party_identification|
        party_identification.encoded_tag! :UserID, details[:user_id] if details[:user_id]
        # party_identification.encoded_tag! :CatalogFirmIdentification
        party_identification.encoded_tag! :ID, details[:company_id]
      end
      party.encoded_tag! :PartyName do |party_name|
        party_name.encoded_tag! :Name, details[:name]
      end
      party.encoded_tag! :PostalAddress do |postal_address|
        postal_address.encoded_tag! :StreetName, details[:street]
        postal_address.encoded_tag! :BuildingNumber, details[:building_number]
        postal_address.encoded_tag! :CityName, details[:city]
        postal_address.encoded_tag! :PostalZone, details[:postal_code]
        postal_address.encoded_tag! :Country do |country|
          country.encoded_tag! :IdentificationCode, details[:country_code]
          country.encoded_tag! :Name, details[:country]
        end
      end
      party.encoded_tag! :PartyTaxScheme do |party_tax_scheme|
        party_tax_scheme.encoded_tag! :CompanyID, details[:tax_number]
        party_tax_scheme.encoded_tag! :TaxScheme, "VAT"
      end if details[:tax_number]
      party.encoded_tag! :RegisterIdentification do |register_identification|
        register_identification.encoded_tag! :RegisterKeptAt, details[:register_kept_at]
        register_identification.encoded_tag! :RegisterFileRef, details[:register_file_ref]
        register_identification.encoded_tag! :RegisterDate, details[:register_date]
      end if details[:register_kept_at]
    end
  end

  def build_invoice_lines(invoice_lines, items)
    items.each_with_index do |item, index|
      invoice_lines.encoded_tag! :InvoiceLine do |invoice_line|
        invoice_line.encoded_tag! :ID, index+1
        invoice_line.encoded_tag! :LineExtensionAmount, item[:line_extension_amount]
        invoice_line.encoded_tag! :LineExtensionAmountTaxInclusive, item[:line_extension_amount_tax_inclusive]
        invoice_line.encoded_tag! :LineExtensionTaxAmount, item[:line_extension_tax_amount]
        invoice_line.encoded_tag! :UnitPrice, item[:unit_price]
        invoice_line.encoded_tag! :UnitPriceTaxInclusive, item[:unit_price_tax_inclusive]
        invoice_line.encoded_tag! :ClassifiedTaxCategory do |classified_tax_category|
          classified_tax_category.encoded_tag! :Percent, item[:tax_percent]
          classified_tax_category.encoded_tag! :VATCalculationMethod, item[:vat_calculation_method]
        end
        invoice_line.encoded_tag! :Item do |item_tag|
          item_tag.encoded_tag! :Description, item[:description] if item[:description]
          item_tag.encoded_tag! :SellersItemIdentification do |sellers_item_identification_tag|
            sellers_item_identification_tag.encoded_tag! :ID, item[:sellers_item_identification]
          end if item[:sellers_item_identification]
        end
        draw_invoice_line_extensions(invoice_line, item) if ledger_item.respond_to?(:draw_invoice_line_extensions)
      end
    end
  end

  def build_tax_sub_totals(tax_total, tax_sub_totals)
    for tax_sub_total in tax_sub_totals
      tax_total.encoded_tag! :TaxSubTotal do |tax_sub_total_tag|
        tax_sub_total_tag.encoded_tag! :TaxableAmount, tax_sub_total[:taxable_amount]
        tax_sub_total_tag.encoded_tag! :TaxInclusiveAmount, tax_sub_total[:tax_inclusive_amount]
        tax_sub_total_tag.encoded_tag! :TaxAmount, tax_sub_total[:tax_amount]
        tax_sub_total_tag.encoded_tag! :AlreadyClaimedTaxableAmount, tax_sub_total[:already_claimed_taxable_amount]
        tax_sub_total_tag.encoded_tag! :AlreadyClaimedTaxAmount, tax_sub_total[:already_claimed_tax_amount]
        tax_sub_total_tag.encoded_tag! :AlreadyClaimedTaxInclusiveAmount, tax_sub_total[:already_claimed_tax_inclusive_amount]
        tax_sub_total_tag.encoded_tag! :DifferenceTaxableAmount, tax_sub_total[:difference_taxable_amount]
        tax_sub_total_tag.encoded_tag! :DifferenceTaxAmount, tax_sub_total[:difference_tax_amount]
        tax_sub_total_tag.encoded_tag! :DifferenceTaxInclusiveAmount, tax_sub_total[:difference_tax_inclusive_amount]
        tax_sub_total_tag.encoded_tag! :TaxCategory do |tax_category|
          tax_category.encoded_tag! :Percent, tax_sub_total[:tax_percent]
        end
      end
    end
  end

  def build_bank_account(xml, details, main_bank_account=false)
    xml.encoded_tag! :PaymentDueDate, details[:payment_due_date] if details[:payment_due_date]
    xml.encoded_tag! :ID, details[:id]
    xml.encoded_tag! :BankCode, details[:bank_code]
    xml.encoded_tag! :Name, details[:name]
    xml.encoded_tag! :IBAN, details[:iban]
    xml.encoded_tag! :BIC, details[:bic]
    xml.encoded_tag! :VariableSymbol, payment_means_detail[:variable_symbol] if main_bank_account
  end

  def build_non_taxed_deposits(xml, details)
    for detail in details
      xml.encoded_tag! :NonTaxedDeposit do |non_taxed_deposit|
        non_taxed_deposit.encoded_tag! :ID, detail[:id]
        non_taxed_deposit.encoded_tag! :VariableSymbol, detail[:variable_symbol]
        non_taxed_deposit.encoded_tag! :DepositAmount, detail[:deposit_amount]
      end
    end
  end

  def build_taxed_deposits(xml, details)
    for detail in details
      xml.encoded_tag! :TaxedDeposit do |taxed_deposit|
        taxed_deposit.encoded_tag! :ID, detail[:id]
        taxed_deposit.encoded_tag! :VariableSymbol, detail[:variable_symbol]
        taxed_deposit.encoded_tag! :TaxableDepositAmount, detail[:taxable_deposit_amount]
        taxed_deposit.encoded_tag! :TaxInclusiveDepositAmount, detail[:tax_inclusive_deposit_amount]
        taxed_deposit.encoded_tag! :ClassifiedTaxCategory do |classified_tax_category|
          classified_tax_category.encoded_tag! :Percent, detail[:tax_percent]
          classified_tax_category.encoded_tag! :VATCalculationMethod, detail[:vat_calculation_method]
        end
      end
    end
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
