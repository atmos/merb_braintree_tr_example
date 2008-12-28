class CreditCardInfo
  include LibXML
  attr_reader :name, :address, :cc_number, :cc_exp

  def initialize(doc)
    params = { 'customer_vault_id' => token, 'report_type' => 'customer_vault'}
    collect_card_info(BrainTree::Query.new(params).run)
  end

  private
  def collect_card_info(doc)
    customer = doc.find('/nm_response/customer_vault/customer').first
    @name = "#{fetch(customer,'first_name')} #{fetch(customer,'last_name')}"
    @address = "#{fetch(customer,'address_1')} (#{fetch(customer,'postal_code')})"
    @cc_number = fetch(customer, 'cc_number')
    @cc_exp = fetch(customer, 'cc_exp')
  end
  def fetch(node, name)
    node.find(name).first.content
  end
end
