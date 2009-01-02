class CreditCards < Application
  def index
    render
  end

  def new
    @credit_card = CreditCard.new
    @credit_card_info = @credit_card.info

    unless message[:transaction_id].nil?
      @credit_card_info = Braintree::TransactionInfo.new(message[:transaction_id])
    end

    @gateway_request = Braintree::GatewayRequest.new(:orderid => Digest::SHA1.hexdigest(Time.now.to_s))
    render
  end

  def new_response
    @gateway_response = Braintree::GatewayResponse.new(params)
    raise Unauthorized unless @gateway_response.is_valid?
    case @gateway_response.response_status
    when 'approved'
      if @gateway_response.cvv_matches?
        session.user.credit_cards.create(:token => @gateway_response.customer_vault_id)
        redirect('/', :message => {:notice => 'Successfully stored your card info securely.'})
      else
        redirect(url(:new_credit_card), :message => {:notice => @gateway_response.cvvresponse_string, :transaction_id => params['transactionid']})
      end
    else
      redirect(url(:new_credit_card), :message => {:notice => @gateway_response.responsetext, :transaction_id => params['transactionid']})
    end
  end

  def edit(id)
    fetch_credit_card(id)
    @credit_card_info = @credit_card.info
    @gateway_request = Braintree::GatewayRequest.new
    render
  end

  def edit_response(id)
    @gateway_response = Braintree::GatewayResponse.new(params.reject { |k,v| k == 'id' })
    raise Unauthorized unless @gateway_response.is_valid?
    case @gateway_response.response_status
    when 'approved'
      redirect(url(:credit_cards), :message => {:notice => 'Successfully updated your info in the vault.'})
    else
      fetch_credit_card(id)
      redirect(url(:edit_credit_card, @credit_card), :message => {:notice => @gateway_response.responsetext})
    end
  end

  def show(id)
    fetch_credit_card(id)
    render
  end

  def destroy(id)
    fetch_credit_card(id)
    @gateway_request = Braintree::GatewayRequest.new
    render
  end
end
