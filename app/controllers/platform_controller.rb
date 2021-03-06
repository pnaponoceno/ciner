# frozen_string_literal: true

class PlatformController < ApplicationController
  before_action :check_admin

  layout 'platform'

  def check_admin
    authenticate_user!
    # redirect_to admin_root_path if user_signed_in? && current_user.admin?
    redirect_to root_path unless user_signed_in?
  end
end
