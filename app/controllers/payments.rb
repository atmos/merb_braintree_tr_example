class Payments < Application
  before :ensure_authenticated
  def index
    render
  end

  def signup
    @gateway_request = Braintree::GatewayRequest.new
    render
  end

  def signup_response
  end
end
