Rails.application.routes.draw do

  namespace :api  do
    namespace :v1 do
      resources :editions
      resources :courses
      resources :criterions
      resources :school_types
      resources :types
      resources :schools

    end
  end

end
