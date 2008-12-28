class Payments < Application
  before :ensure_authenticated
  def index
    render
  end

  def new(credit_card_id)
    fetch_credit_card(credit_card_id)

    @gateway_request = Braintree::GatewayRequest.new(:amount => 0.99)
    render
  end

  def new_response(credit_card_id)
    fetch_credit_card(credit_card_id)

    @gateway_response = Braintree::GatewayResponse.new(params.reject { |k,v| k == 'credit_card_id' })
#    raise Unauthorized unless @gateway_response.is_valid?
    Merb.logger.info @gateway_response.inspect
    case @gateway_response.response_status
    when 'approved'
      redirect(url(:credit_card, @credit_card), :message => {:notice => 'Successfully charged your account.'})
    else
      redirect(url(:new_credit_card_payment), :message => {:notice => @gateway_response.responsetext})
    end
  end
end
