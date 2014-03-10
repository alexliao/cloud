Cloud::Application.routes.draw do
  # map.connect '', :controller => "default", :action => "index"
  # map.connect 'about', :controller => "default", :action => "about"
  # map.connect 'apps/:id', :controller => "apps", :action => "show", :id => /\d+/
  
  resources :reports
  resources :apps

  root :to => 'default#index'
  # match 'apps/:id' => 'apps#show', :id => /\d+/


  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id/json', :format => 'json'
  # map.connect ':controller/:action/:id/', :format => 'xml'
  match ':controller(/:action(/:id))(.:format)'
  match ':controller/:action/:id/json', :format => 'json'
  match ':controller/:action/:id/xml', :format => 'xml'
end
