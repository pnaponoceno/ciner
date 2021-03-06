# frozen_string_literal: true

class CurriculumVideo < ActiveRecord::Base
  belongs_to :curriculum

  # Uploaders
  mount_uploader :media, CurriculumVideoUploader

  # Validations
  validates :media,
            presence: true

  validates :media, file_size: { less_than_or_equal_to: 10.megabytes }
end
