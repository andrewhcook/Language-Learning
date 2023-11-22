Rails.application.routes.draw do
  # Routes for the Expression resource:
  # get("/", {:controller => "homepage", :action => "index"})

  root "homepage#index"

  # file uploader
  post 'upload_file' => 'file_upload#upload'
  # CREATE
  post("/insert_expression", { :controller => "expressions", :action => "create" })
          
  # READ
  get("/expressions", { :controller => "expressions", :action => "index" })
  
  get("/expressions/:path_id", { :controller => "expressions", :action => "show" })
  
  # UPDATE
  
  post("/modify_expression/:path_id", { :controller => "expressions", :action => "update" })
  
  # DELETE
  get("/delete_expression/:path_id", { :controller => "expressions", :action => "destroy" })

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

  # Routes for the Learning path resource:

  # CREATE
  post("/insert_learning_path", { :controller => "learning_paths", :action => "create" })
          
  # READ
  get("/learning_paths", { :controller => "learning_paths", :action => "index" })
  
  get("/learning_paths/tutorial", {:controller => "learning_paths", :action => "tutorial"})
  
  get("/learning_paths/instructions", {:controller => "learning_paths", :action => "show_instructions"})
  
  get("/learning_paths/:path_id", { :controller => "learning_paths", :action => "show" })
  
  # UPDATE
  
  post("/modify_learning_path/:path_id", { :controller => "learning_paths", :action => "update" })
  
  # DELETE
  get("/delete_learning_path/:path_id", { :controller => "learning_paths", :action => "destroy" })

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
  post("flashcards/result", {:controller => "flashcards", :action => "show_results"})
  get("flashcards/question", {:controller => "flashcards", :action => "show_question_card"})
  get("flashcards/quiz", {:controller => "flashcards", :action => "show_quiz_card"})
  get("flashcards/show_quiz_results", {:controller => "flashcards", :action => "show_quiz_results"})
  
  post "/translations/:id/update_status", { :controller => "translations", :action => "update_status" }
  devise_for :users
 
  
end
