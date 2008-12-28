class Invoice
  include LibXML
#  attr_reader :first_name, :last_name, :address_1, :postal_code, :cc_number

  def self.parse(doc)
    results = [ ]
    doc.find('/nm_response').each do |node|
      invoice = new
      puts node
#      results << invoice
    end
    results
  end
end
