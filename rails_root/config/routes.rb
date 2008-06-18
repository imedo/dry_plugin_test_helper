ActionController::Routing::Routes.draw do |map|
  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'
  
  # Default route
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end