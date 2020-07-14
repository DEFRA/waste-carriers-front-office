# frozen_string_literal: true

class PasswordsController < ApplicationController

  before_action :authenticate_user!
  before_action :assign_user

  def edit; end

  def update
    if @user.update_with_password(user_params)
      bypass_sign_in(@user)
      redirect_to fo_path
    else
      render "edit"
    end
  end

  private

  def assign_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
