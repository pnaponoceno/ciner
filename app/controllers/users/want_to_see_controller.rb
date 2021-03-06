# frozen_string_literal: true

module Users
  class WantToSeeController < ApplicationController
    # exposes
    expose(:user)
    expose(:filmables) { user.user_want_to_see }
  end
end
