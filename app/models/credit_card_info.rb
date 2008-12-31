class CreditCardInfo
  include LibXML
  attr_reader :name, :address

  def initialize(token = nil)
    params = { 'customer_vault_id' => token, 'report_type' => 'customer_vault'}
    collect_card_info(Braintree::Query.new(params).run) unless token.nil? or token.blank?
  end

  def method_missing(sym, *args, &block)
    begin
      if %w(first_name last_name email address_1 city state postal_code country cc_exp cc_number).include?(sym.to_s)
        fetch(@customer, sym.to_s) 
      end
    rescue
      super(sym, args, &block)
    end
  end

  private
  def collect_card_info(doc)
    @customer = doc.find('/nm_response/customer_vault/customer').first
    @name = "#{fetch(@customer,'first_name')} #{fetch(@customer,'last_name')}"
    @address = "#{fetch(@customer,'address_1')} (#{fetch(@customer,'postal_code')})"
  end

  def fetch(node, name)
    return '' if node.nil?
    node.find(name).first.content
  end
end
