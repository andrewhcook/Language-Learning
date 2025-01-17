Rails.application.routes.draw do
  # Routes for the Expression resource:

  root 'homepage#index'
  get 'instructions' => 'homepage#instructions'
  # file uploader
  post 'upload_file' => 'file_upload#upload'

  get('/translations', { controller: 'translations', action: 'index' })
  get('/translations/needs_review', { controller: 'translations', action: 'need_review_show' })
  get('/translations/to_see_again', { controller: 'translations', action: 'to_see_again' })
  get('/translations/:path_id', { controller: 'translations', action: 'show' })

  post '/translations/:id/update_status', { controller: 'translations', action: 'update_status' }

  # Routes for the Learning path resource:

  # CREATE
  post('/insert_learning_path', { controller: 'learning_paths', action: 'create' })

  # READ
  get('/learning_paths', { controller: 'learning_paths', action: 'index' })

  get('/learning_paths/:path_id', { controller: 'learning_paths', action: 'show' })

  # DELETE
  get('/delete_learning_path/:path_id', { controller: 'learning_paths', action: 'destroy' })

  # Routes for Flashcards
  post('flashcards/result', { controller: 'flashcards', action: 'show_results' })
  get('flashcards/question', { controller: 'flashcards', action: 'show_question_card' })
  get('flashcards/quiz', { controller: 'flashcards', action: 'show_quiz_card' })
  get('flashcards/show_quiz_results', { controller: 'flashcards', action: 'show_quiz_results' })
  post('/tts', { controller: 'tts', action: 'tts_api_call' })
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
end
