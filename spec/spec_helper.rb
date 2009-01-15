require "rubygems"

# Add the local gems dir if found within the app root; any dependencies loaded
# hereafter will try to load from the local gems before loading system gems.
if (local_gem_dir = File.join(File.dirname(__FILE__), '..', 'gems')) && $BUNDLE.nil?
  $BUNDLE = true; Gem.clear_paths; Gem.path.unshift(local_gem_dir)
end

require "merb-core"
require "spec" # Satisfies Autotest and anyone else not using the Rake tasks
require 'pp'
require 'ruby-debug'
require File.expand_path(File.dirname(__FILE__)+'/spec_helpers/edit_form_helper')
require File.expand_path(File.dirname(__FILE__)+'/spec_helpers/braintree/api_helper')

# this loads all plugins required in your init file so don't add them
# here again, Merb will do it for you
Merb.start_environment(:testing => true, :adapter => 'runner', :environment => ENV['MERB_ENV'] || 'test')

Spec::Runner.configure do |config|
  config.include(Merb::Test::ViewHelper)
  config.include(Merb::Test::RouteHelper)
  config.include(Merb::Test::ControllerHelper)

  config.before(:all) do
    DataMapper.auto_migrate! if Merb.orm == :datamapper
    user = User.create(:login => 'quentin', :email => 'quentin@example.com',
                :password => 'lolerskates', :password_confirmation => 'lolerskates')
  end

  def quentin_form_info
    { 'firstname' => 'Quentin', 'lastname' => 'Blake',
      'email' => 'quentin@example.org', 'address1' => '187 Drive By Blvd',
      'city' => 'Compton', 'state' => 'CA', 'country' => 'US', 'zip' => '90220',
      'cvv' => '999', 'ccexp' => '1010', 'ccnumber' => '4111111111111111',
      'customer_vault' => 'add_customer', 'customer_vault_id' => '',
      'redirect' => 'http://example.org/credit_cards/new_response'
    }
  end
end

given "an authenticated user" do
  response = request url(:perform_login), :method => "PUT", 
                     :params => { :login => 'quentin', :password => 'lolerskates' }
  response.should redirect_to '/'
end

given "a user with a credit card in the vault" do
  response = request url(:perform_login), :method => "PUT", 
                     :params => { :login => 'quentin', :password => 'lolerskates' }
  response.should redirect_to '/'
  response = request("/credit_cards/new")

  api_response = Braintree::Spec::ApiRequest.new('10.00', nil,
                            quentin_form_info.merge({'type'=>'sale', 'payment'=>'creditcard'}))

  response = request("/credit_cards/new_response", :params => api_response.params)
  response.should redirect_to('/credit_cards')
end
