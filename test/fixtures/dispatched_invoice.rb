# -*- encoding : utf-8 -*-
class DispatchedInvoice < BasicInvoice
  def dispatches
    {"Email" => ["joska@koska.cz", "koska@koska.cz"],
     "Postage" => "common"}
  end
end
