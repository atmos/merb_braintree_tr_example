class CreditCards < Application
  before :ensure_authenticated
  def index
    render
  end

  def new
    @gateway_request = Braintree::GatewayRequest.new
    render
  end

  def new_response
    @gateway_response = Braintree::GatewayResponse.new(params)
    case @gateway_response.response_status
    when 'approved'
      session.user.credit_cards.create(:token => @gateway_response.customer_vault_id)
      redirect('/', :message => {:notice => 'Successfully stored your card info securely.'})
    else
      redirect(url(:new_credit_card), :message => {:notice => @gateway_response.responsetext})
    end
  end

  def show(id)
    fetch_credit_card(id)
    render
  end
end
