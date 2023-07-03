class UsersController < ApplicationController
    acts_as_token_authentication_handler_for User, except: [:login, :create]
    before_action :is_admin_authentication, only: [:index]

    def login
        user = User.find_by(email: params[:email])
        if user.valid_password?(params[:password])
            render json: user, status: :ok
        else
            render json:'Senha Inválida', status: :unauthorized
        end
    rescue StandardError => e
        render json: e, stautus: :unauthorized
    end

    def index
        render json: User.all, status: :ok
    rescue StandardError => e
        render json: {error:e.message}, status: :bad_request
    end
    
    def show
        user = User.find(params[:email])
        render json: user, status: :ok
    rescue ActiveRecord::RecordNotFound => e
        render json: { error: e.message }, status: :not_found
    end
    
    def create
        user = User.new(user_params)
        user.save!
        render json: user, status: :created
    rescue StandardError => e
        render json: { error: e.message }, status: :bad_request
    end
    
    def update
        user = current_user
        user.update!(user_params)
        render json: user, status: :ok
    rescue ActiveRecord::RecordNotFound => e
        render json: { error: e.message }, status: :not_found
    rescue StandardError => e
        render json: { error: e.message }, status: :bad_request
    end
    
    def delete
        user = current_user
        user.destroy!
        render json: user, status: :ok
    rescue ActiveRecord::RecordNotFound => e
        render json: { error: e.message }, status: :not_found
    rescue StandardError => e
        render json: { error: e.message }, status: :bad_request
    end
    
    private
    
    def user_params
        params.require(:user).permit(:name, :email, :password, :is_admin, :id           
        )
    end

end
