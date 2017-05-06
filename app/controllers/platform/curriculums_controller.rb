# frozen_string_literal: true

module Platform
  class CurriculumsController < PlatformController
    include Platform::CurriculumsBreadcrumb

    # exposes
    expose(:curriculums) { Curriculum.all }
    expose(:curriculum, attributes: :curriculum_attributes)

    private

    def resource
      curriculum
    end

    def resource_title
      curriculum.name
    end

    def index_path
      platform_curriculums_path
    end

    def show_path
      platform_curriculum_path(resource)
    end

    def resource_params
      curriculum_params
    end

    def curriculum_params
      params.require(:curriculum).permit(
        :content, :user_id, :filmable_id, :filmable_type, :filmable, :rating
      )
    end
  end
end
