class CreditCard
  include LibXML
  include DataMapper::Resource

  property :id,     Serial
  property :token,  String, :nullable => false

  belongs_to :user
#  validates_is_unique :token, :scope => [:user_id]

  def card_info
    @card_info ||= CreditCardInfo.new(self)
  end
  
  def invoices
    @invoices ||= CreditCardInvoice.parse(self)
  end
end
