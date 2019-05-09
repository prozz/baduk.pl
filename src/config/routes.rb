ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
map.connect '', :controller => "games"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
  
  map.connect 'login', :controller => "account", :action => "login"
  map.connect 'logout', :controller => "account", :action => "logout"
  map.connect 'signup', :controller => "account", :action => "signup"
  map.connect 'forgotten_password', :controller => "account", :action => "forgotten_password"
  map.connect 'profile', :controller => "account", :action => "profile"
  map.connect 'profile/:id', :controller => "account", :action => "profile"
  map.connect 'turniej', :controller => "tournament", :action => "index"

  map.connect '*path', :controller => 'static_content'
end
