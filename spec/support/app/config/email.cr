private class SpecDeliverLaterStrategy < Carbon::DeliverLaterStrategy
  def run(email, &block)
    block.call
  end
end

BaseEmail.configure do |settings|
  settings.adapter = Carbon::DevAdapter.new
  settings.deliver_later_strategy = SpecDeliverLaterStrategy.new
end
