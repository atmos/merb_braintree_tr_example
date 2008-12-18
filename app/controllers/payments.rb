class Payments < Application
  before :ensure_authenticated
  def index
    render
  end

  def signup
    render
  end
end
