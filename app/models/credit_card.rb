class CreditCard
  include LibXML
  include DataMapper::Resource

  property :id,     Serial
  property :token,  String, :nullable => false
  
  attr_reader :name, :address, :cc_number, :cc_exp

  belongs_to :user
#  validates_is_unique :token, :scope => [:user_id]

  def card_info
    @card_info ||= CreditCardInfo.new(self)
  end
  
  def invoices
    params = { 'customer_vault_id' => token }
    @invoices ||= Invoice.parse(BrainTree::Query.new(params).run)
  end
end
