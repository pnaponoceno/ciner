# frozen_string_literal: true

module Admin
  class PlayingFilmablesController < AdminController
    include Admin::PlayingFilmablesBreadcrumb

    # exposes
    expose(:filmables) { Movie.current_playing }

    PER_PAGE = 50

    def index
      return if filmables.blank?
    end

    private

    # Filtering

    def paginated_filmables
      filmables.page(params[:page]).per(PER_PAGE)
    end
  end
end
