Rails.application.routes.draw do
  # Routes for the Word resource:

  # CREATE
  post("/insert_word", { :controller => "words", :action => "create" })
          
  # READ
  get("/words", { :controller => "words", :action => "index" })
  
  get("/words/:path_id", { :controller => "words", :action => "show" })
  
  # UPDATE
  
  post("/modify_word/:path_id", { :controller => "words", :action => "update" })
  
  # DELETE
  get("/delete_word/:path_id", { :controller => "words", :action => "destroy" })

  #------------------------------

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
