# Go to http://wiki.merbivore.com/pages/init-rb
require 'config/dependencies.rb'
require 'digest/md5'
require 'net/https'
require 'pp'

use_orm :datamapper
use_test :rspec
use_template_engine :haml
 
Merb::Config.use do |c|
  c[:use_mutex] = false
  c[:session_store] = 'cookie'  # can also be 'memory', 'memcache', 'container', 'datamapper
  
  # cookie session store configuration
  c[:session_secret_key]  = 'cdd210aa9453eb752f5df31c601fcce419b8b7ad'  # required for cookie session store
  c[:session_id_key] = '_merb_braintree_tr_example_session_id' # cookie session id key, defaults to "_session_id"
end
 
Merb::BootLoader.before_app_loads do
  BRAINTREE = { }
  # This will get executed after dependencies have been loaded but before your app's classes have loaded.
end
 
Merb::BootLoader.after_app_loads do
  bt = YAML.load_file(Merb.root / 'config' / 'braintree.yml')
  if bt[Merb.env]
    bt[Merb.env].each do |k,v|
      BRAINTREE[k.to_sym] = v
    end
  end
  # This will get executed after your app's classes have been loaded.
  if Merb.env == 'development'
    DataMapper.auto_migrate!
    user = User.create(:login => 'quentin', :email => 'quentin@example.com',
                :password => 'foo', :password_confirmation => 'foo')
    user.credit_cards.create(:token => '1379118828')  # something i created manually
  end
end
