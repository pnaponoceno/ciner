# frozen_string_literal: true

module Admin
  class SeriesController < AdminController
    include Admin::SeriesBreadcrumb

    # exposes
    expose(:series) { Serie.all }
    expose(:serie, attributes: :serie_attributes)
    expose(:broadcasts) { serie.broadcasts }

    expose(:playing_filmables) { Serie.current_playing.limit(20) }
    expose(:playing_soon_filmables) { Serie.playing_soon.limit(20) }
    expose(:featured_filmables) { Serie.featured(10) }
    expose(:available_netflix_filmables) { Serie.available_netflix.limit(20) }

    expose(:countries) { Country.all }
    expose(:age_ranges) { AgeRange.all }

    PER_PAGE = 50

    def index
      self.series = paginated_series
    end

    def new
      new_serie = Serie.new
      # new_serie.title = "Nova série"
      # new_serie.start_year = 2018
      new_serie.save(validate: false)
      redirect_to edit_admin_series_path(new_serie)
    end

    def show
      force_update = params[:force_update].present? && params[:force_update] == "true" ? true : false
      serie.api_transform(force_update)
    end

    def bulk_destroy
      if params[:destroy] && params[:destroy][:ids]
        ids = params[:destroy][:ids]
        ids.each do |id_to_destroy|
          status = Serie.find(id_to_destroy).destroy
        end
        respond_to do |format|
          format.json do
            if status
              render json: { status: 'OK' }
            else
              render json: { status: 'error' }
            end
          end
        end
      end
    end

    private

    def resource
      serie
    end

    def resource_title
      serie.title
    end

    def index_path
      admin_series_index_path
    end

    def show_path
      admin_series_index_path(resource)
    end

    def serie_params
      params.require(:serie).permit(
        :original_title,
        :title,
        :start_year,
        :finish_year,
        :length,
        :synopsis,
        :release,
        :brazilian_release,
        :city_id,
        :state_id,
        :country_id,
        :age_range_id,
        :cover,
        :studio_id,
        :number_episodes,
        :aired_episodes,
        :created_at,
        :updated_at,
        :omdb_directors,
        :omdb_writers,
        :omdb_actors,
        :omdb_genre,
        :omdb_rated,
        :omdb_id,
        :omdb_trailer,
        :trailer,
        :tmdb_id,
        :imdb_id,
        :number_of_seasons,
        :playing,
        :user_id,
        :lock_updates,
        :countries,
        :playing_soon,
        :available_netflix,
        :available_amazon,
        :last_released,
        :finish_year,
        :status,
        filmable_professionals_attributes: %i[
          set_function_id
          professional_id
          observation
          filmable_id
          filmable_type
          filmable
          id
          _destroy
        ]
      )
    end

    def resource_params
      serie_params
    end

    # Filtering

    def paginated_series
      filtered_serie.page(params[:page]).per(PER_PAGE)
    end

    def filtered_serie
      series.filter_by(searched_series, params.fetch(:filter, ''))
    end

    def searched_series
      series.search(current_user, params.fetch(:search, ''))
    end

    # Filters

    def filtered_states
      return unless params[:filter] && params[:filter][:country].present?

      Country.find(params[:filter][:country]).states
    end

    def filtered_cities
      return unless params[:filter] && params[:filter][:state].present?

      State.find(params[:filter][:state]).cities
    end
  end
end
