class Payments < Application
  before :ensure_authenticated
  def index
    render
  end

  def new(credit_card_id)
    fetch_credit_card(credit_card_id)

    @gateway_request = Braintree::GatewayRequest.new
    render
  end

  def new_response(credit_card_id)
    @gateway_response = Braintree::GatewayResponse.new(params)
    Merb.logger.info @gateway_response.inspect
#    case @gateway_response.response_status
#    when 'approved'
#      session.user.credit_cards.create(:token => @gateway_response.customer_vault_id)
#      redirect('/', :message => {:notice => 'Successfully stored your card info securely.'})
#    else
#      redirect(url(:add_card), :message => {:notice => @gateway_response.responsetext})
#    end
  end
end
