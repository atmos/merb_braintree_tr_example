# dependencies are generated using a strict version, don't forget to edit the dependency versions when upgrading.
merb_gems_version = "1.0.6.1"
dm_gems_version   = "0.9.8"

#dependency 'rfuzz', '=0.9', :require_as => 'rfuzz/client'
#dependency 'bt-integration-core', '=0.0.1', :require_as => 'braintree'

# For more information about each component, please read http://wiki.merbivore.com/faqs/merb_components
dependency "merb-action-args", merb_gems_version
dependency "merb-assets", merb_gems_version  
dependency "merb-cache", merb_gems_version   
dependency "merb-helpers", merb_gems_version 
dependency "merb-mailer", merb_gems_version  
dependency "merb-slices", merb_gems_version  
dependency "merb-auth-core", merb_gems_version
dependency "merb-auth-more", merb_gems_version
dependency "merb-auth-slice-password", merb_gems_version
dependency "merb-param-protection", merb_gems_version
dependency "merb-exceptions", merb_gems_version
 
dependency "dm-core", dm_gems_version         
dependency "dm-aggregates", dm_gems_version   
dependency "dm-migrations", dm_gems_version   
dependency "dm-timestamps", dm_gems_version   
dependency "dm-types", dm_gems_version        
dependency "dm-validations", dm_gems_version  

dependency 'rcov', '>0.0', :require_as => nil

dependency 'nokogiri', '=1.0.7', :require_as => nil
dependency 'webrat', '=0.3.2', :require_as => nil
dependency 'mongrel', '>1.0', :require_as => nil
dependency 'libxml-ruby', '=0.9.7', :require_as => 'libxml'
