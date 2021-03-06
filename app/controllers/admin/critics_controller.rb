# frozen_string_literal: true

module Admin
  class CriticsController < AdminController
    include Admin::CriticsBreadcrumb

    # Params
    PERMITTED_PARAMS = %i[
      content user_id filmable_id filmable_type filmable rating
      status origin featured spoiler quick
    ].freeze

    # exposes
    expose(:critics) { Critic.ordered_by_status }
    expose(:critic, attributes: :critic_attributes)

    PER_PAGE = 10

    def index
      return if critics.blank?

      self.critics = paginated_critics
    end

    private

    def resource
      critic
    end

    def resource_title
      critic.name
    end

    def index_path
      admin_critics_path
    end

    def show_path
      admin_critic_path(resource)
    end

    def resource_params
      critic_params
    end

    def critic_params
      params.require(:critic).permit(PERMITTED_PARAMS)
    end

    # Filtering

    def paginated_critics
      filtered_critic.page(params[:page]).per(PER_PAGE)
    end

    def filtered_critic
      critics.filter_by(searched_critics, params.fetch(:filter, ''))
    end

    def searched_critics
      critics.search(current_user, params.fetch(:search, ''))
    end
  end
end
