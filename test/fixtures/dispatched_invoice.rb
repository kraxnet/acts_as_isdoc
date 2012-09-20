# -*- encoding : utf-8 -*-
class DispatchedInvoice < BasicInvoice
  def draw_dispatches(invoice, dispatches)
    invoice.tag! :Extensions do |extensions|
      extensions.tag! :Dispatches, :xmlns => "http://czreg.cz/isdoc/namespace/dispatch-1.0" do |disps|
        disps.encoded_tag! :Email, "joska@koska.cz"
        disps.encoded_tag! :Postage, "common"
      end
    end
  end
end
