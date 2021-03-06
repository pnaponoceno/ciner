# frozen_string_literal: true

class Movie < ActiveRecord::Base
  include Searchables::Movie
  include FilmProfitable
  include Tmdb
  include UserActionable
  include CommentManageable

  # Prevents deleting
  acts_as_paranoid

  # Associations
  belongs_to :age_range
  belongs_to :user

  has_many :critics, as: :filmable, dependent: :destroy
  has_many :user_filmable_ratings, as: :filmable, dependent: :destroy
  has_many :broadcast_broadcastables, as: :broadcastable, dependent: :destroy
  has_many :broadcasts, through: :broadcast_broadcastables
  has_many :filmable_professionals, as: :filmable, dependent: :destroy
  has_many :professionals, through: :filmable_professionals
  has_many :user_filmables, as: :filmable, dependent: :destroy

  has_many :comments, as: :commentable, dependent: :destroy

  # Uploaders
  mount_uploader :cover, CoverUploader

  # Validations
  validates :original_title,
            :year,
            presence: true

  # Delegations
  delegate :name, to: :age_range, allow_nil: true, prefix: true

  # Nested
  accepts_nested_attributes_for :filmable_professionals,
                                allow_destroy: true,
                                reject_if: :all_blank

  # Aliases
  alias_attribute :text, :title_str

  # Callbacks
  before_destroy :destroy_visits

  # Scopes

  def self.by_year(year)
    where(year: year)
  end

  # Filter

  def self.filter_by(collection, params)
    return collection unless params.present?

    result = collection
    result = result.by_year(params[:year]) if params[:year].present?

    result
  end

  def original_title_str
    return original_title unless year

    original_title.gsub("(#{year})", "")
  end

  def self.current_playing
    where(playing: true).order('brazilian_release DESC')
  end

  def filmable_year
    year
  end

  def filmable_year_str
    "(#{year})"
  end

  def original_title_filmable_str
    "#{original_title_str} #{filmable_year_str}"
  end

  def length_str
    length = self.length
    return "" unless length

    length = begin
               Integer(length.gsub("min", "").strip)
             rescue StandardError
               0
             end
    hours = 0
    while length >= 60
      length -= 60
      hours += 1
    end

    return "#{hours}h" if length == 0 && hours > 0
    return "#{length}min" if length > 0 && hours == 0
    return "#{hours}h#{length}min" if length > 0 && hours > 0

    ""
  end

  def self.featured(limit = 15)
    ids = Visit.where(action: 'show').where("controller like ?", "%movies%").pluck(:resource_id)

    result = Hash.new(0)

    ids.each { |v| result[v] += 1 }

    result = result.sort_by { |_k, v| v }.to_h

    where(id: result.keys.first(limit * 3)).limit(limit)
  end

  def destroy_visits
    object = self
    Visit.where("action = 'show' AND controller LIKE ? AND resource_id = ?", "%#{object.class.name.pluralize.downcase}%", object.id).destroy_all
  end
end
