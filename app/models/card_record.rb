class CardRecord
  include LibXML
  attr_reader :first_name, :last_name, :address_1, :postal_code, :cc_number

  def initialize(doc)
    @doc = LibXML::XML::Document.string(doc)
    customer = @doc.find('/nm_response/customer_vault/customer').first
    %w(first_name last_name address_1 postal_code cc_number).each do |k|
      value = customer.find(k).first.content
      instance_variable_set("@#{k}", value)
    end
  end
end
