Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      %w[clients managers].each do |role|
        namespace role do
          post :tokens, to: "#{role.singularize}_token#create"
          post :registrations, to: 'registrations#create'

          resources :issues
        end
      end

      scope 'managers/issues/:id', controller: 'managers/issues' do
        patch :assign
        patch :unassign
      end

    end
  end
end
