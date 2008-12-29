class Payments < Application
  def index
    render
  end

  def new(credit_card_id)
    fetch_credit_card(credit_card_id)

    @gateway_request = Braintree::GatewayRequest.new
    render
  end

  def new_response(credit_card_id)
    @gateway_response = Braintree::GatewayResponse.new(params.reject { |k,v| k == 'credit_card_id' })
    raise Unauthorized unless @gateway_response.is_valid?
    case @gateway_response.response_status
    when 'approved'
      fetch_credit_card(credit_card_id)
      redirect(url(:credit_card, @credit_card), :message => {:notice => 'Successfully charged your account.'})
    else
      redirect(url(:new_credit_card_payment), :message => {:notice => @gateway_response.responsetext})
    end
  end
end
