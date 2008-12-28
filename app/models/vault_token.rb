class VaultToken
  include DataMapper::Resource
  attr_accessor :card_info

  property :id,     Serial
  property :token,  String, :nullable => false

  belongs_to :user
#  validates_is_unique :token, :scope => [:user_id]

  def card_info
    params = { 'customer_vault_id' => token, 'report_type' => 'customer_vault'}
    @card_info ||= CardRecord.new(BrainTree::Query.new(params).run)
  end
  
  def invoices
    params = { 'customer_vault_id' => token }
    @invoices ||= Invoice.parse(BrainTree::Query.new(params).run)
  end
end
