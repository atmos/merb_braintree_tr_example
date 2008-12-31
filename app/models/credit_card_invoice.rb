class CreditCardInvoice
  include LibXML
  attr_accessor :transaction_info
  def self.parse(credit_card)
    params = { 'customer_vault_id' => credit_card.token }

    doc = Braintree::Query.new(params).run
    doc.find('/nm_response/transaction').map do |node|
      invoice = new
      transaction_id = node.find('transaction_id').first.content
      invoice.transaction_info = Braintree::TransactionInfo.new(transaction_id)
      invoice
    end
  end
end
