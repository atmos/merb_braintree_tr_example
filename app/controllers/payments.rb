class Payments < Application
  before :ensure_authenticated
  def index
    uri = Addressable::URI.parse(BRAINTREE[:query_api_url])
#    client = RFuzz::HttpClient.new(uri.host, 443, :use_ssl => true)
#    client.get(uri.path, :query => { 'username' => BRAINTREE[:username],
#                                     'password' => BRAINTREE[:password],
#                                     'customer_vault_id' => session.user.vault_tokens.first.token,
#                                     'report_type' => 'customer_vault'})
#    req = Net::HTTP::Get.new(uri.path)
#    res = Net::HTTP.start(uri.host, 443) do |http|
#      http.request(req, { 
#                          'username' => BRAINTREE[:username],
#                          'password' => BRAINTREE[:password],
#                          'customer_vault_id' => session.user.vault_tokens.first.token,
#                          'report_type' => 'customer_vault'})
#    end
    render
  end

  def signup
    @gateway_request = Braintree::GatewayRequest.new
    render
  end

  def signup_response
    @gateway_response = Braintree::GatewayResponse.new(params)
    case @gateway_response.response_status
    when 'approved'
      session.user.vault_tokens.create(:token => @gateway_response.customer_vault_id)
      redirect('/', :message => {:notice => @gateway_response.responsetext})
    else
      redirect(url(:signup), :message => {:notice => @gateway_response.responsetext})
    end
  end
end
