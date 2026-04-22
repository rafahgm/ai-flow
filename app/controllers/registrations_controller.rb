class RegistrationsController < ApplicationController
  allow_unauthenticated_access only: %i[new create]
  before_action :redirect_if_authenticated, only: %i[new create]

  def new
    render inertia: {}
  end

  def create
    user = User.new(user_params)

    if user.save
      start_new_session_for user
      redirect_to dashboard_path, notice: "Conta criada com sucesso."
    else
      redirect_to signup_path, inertia: { errors: user.errors.to_hash(true) }
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end
