Rails.application.routes.draw do

  root to: 'high_voltage/pages#show' , id: 'index'

  get "/debugger" , to: "debugger#index" , as: :debugger_index

  get "/blog" , to: "blog#index" , as: :blog_index
  get "/blog/*title" , to: "blog#post" , as: :blog_post

end
