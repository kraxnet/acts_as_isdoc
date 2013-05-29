# -*- encoding : utf-8 -*-
class DispatchedInvoice < BasicInvoice
  def dispatches
    {:emails => ["joska@koska.cz", "koska@koska.cz"],
     :postage => "common"}
  end
end
