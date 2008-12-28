class Payments < Application
  before :ensure_authenticated
  def index
    @tokens = session.user.vault_tokens
    render
  end

  def signup
    @gateway_request = Braintree::GatewayRequest.new
    render
  end

  def signup_response
    @gateway_response = Braintree::GatewayResponse.new(params)
    Merb.logger.info @gateway_response.inspect
    case @gateway_response.response_status
    when 'approved'
      session.user.vault_tokens.create(:token => @gateway_response.customer_vault_id)
      redirect('/', :message => {:notice => @gateway_response.responsetext})
    else
      redirect(url(:signup), :message => {:notice => @gateway_response.responsetext})
    end
  end
end
