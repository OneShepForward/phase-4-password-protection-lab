class UsersController < ApplicationController
rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable
before_action :authorize, only: [:show]

    def create
        user = User.create(user_params)
        byebug
        if user.valid?
            session[:user_id] = user.id
            render json: user, status: :created
        else
            render json: { error: user.errors.full_messages }, status: 422
        end
    end

    def show
        user = User.find_by(id: session[:user_id])
        render json: user
    end

    private

    def user_params
        params.permit(:username, :password, :password_confirmation)
    end

    def authorize
        render json: {error: "Not authorized"}, status: :unauthorized unless session.include? :user_id 
    end

    def render_unprocessable(exception)
        render json: { errors: exception.record.errors.full_message }, status: :unprocessable_entity
    end
end
