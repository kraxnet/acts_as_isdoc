# -*- encoding : utf-8 -*-
class ExtendedInvoice < BasicInvoice
  def draw_invoice_line_extensions(invoice_line, item)
    invoice_line.tag! :Extensions do |extensions|
      extensions.tag! :Domains, :xmlns=>"http://www.xnet.cz/xml/isdoc/domain-1.0" do |domain|
        domain.tag! :Name, item[:name]
        domain.tag! :Since, item[:since]
        domain.tag! :Till, item[:till]
      end
    end
  end
end
