class CreditCardInvoice
  include LibXML
  def self.parse(credit_card)
    params = { 'customer_vault_id' => credit_card.token }

    doc = BrainTree::Query.new(params).run
    doc.find('/nm_response/transaction').map do |node|
      invoice = new
      puts node
    end
  end
end
