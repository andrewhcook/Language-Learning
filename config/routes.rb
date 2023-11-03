Rails.application.routes.draw do
  # Routes for the Learning path resource:
  root "learning_paths#index"
  # CREATE
  post("/insert_learning_path", { :controller => "learning_paths", :action => "create" })
          
  # READ
  get("/learning_paths", { :controller => "learning_paths", :action => "index" })
  
  get("/learning_paths/:path_id", { :controller => "learning_paths", :action => "show" })
  
  # UPDATE
  
  post("/modify_learning_path/:path_id", { :controller => "learning_paths", :action => "update" })
  
  # DELETE
  get("/delete_learning_path/:path_id", { :controller => "learning_paths", :action => "destroy" })

  #------------------------------

  # Routes for the Translation resource:

  # CREATE
  post("/insert_translation", { :controller => "translations", :action => "create" })
          
  # READ
  get("/translations", { :controller => "translations", :action => "index" })
  
  get("/translations/:path_id", { :controller => "translations", :action => "show" })
  
  # UPDATE
  
  post("/modify_translation/:path_id", { :controller => "translations", :action => "update" })
  
  # DELETE
  get("/delete_translation/:path_id", { :controller => "translations", :action => "destroy" })

  #------------------------------

  # Routes for the Language resource:

  # CREATE
  post("/insert_language", { :controller => "languages", :action => "create" })
          
  # READ
  get("/languages", { :controller => "languages", :action => "index" })
  
  get("/languages/:path_id", { :controller => "languages", :action => "show" })
  
  # UPDATE
  
  post("/modify_language/:path_id", { :controller => "languages", :action => "update" })
  
  # DELETE
  get("/delete_language/:path_id", { :controller => "languages", :action => "destroy" })

  #------------------------------

  devise_for :users
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
