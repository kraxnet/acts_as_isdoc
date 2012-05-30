# -*- encoding : utf-8 -*-
class ExtendedInvoice < BasicInvoice
  def draw_invoice_line_extensions(invoice_line, item)
    invoice_line.tag! :Extensions do |extensions|
      extensions.tag! :domain, :xmlns=>"http://www.xnet.cz/xml/isdoc/domain-1.0" do |domain|
        domain.tag! :fqdn, "fqdn.cz"
        domain.tag! :since, "2009-01-01"
        domain.tag! :till, "2010-01-01"
        domain.tag! :period, "1Y"
      end
    end
  end
end
