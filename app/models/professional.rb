# frozen_string_literal: true

class Professional < ActiveRecord::Base
  include Searchables::Professional

  acts_as_paranoid

  TMDB_API_KEY = "8802a6c6583ac6edc44bea8d577baa97"
  BASE_URL = "https://api.themoviedb.org/3/person"

  # Associations
  belongs_to :user
  belongs_to :city
  belongs_to :state
  belongs_to :country
  belongs_to :set_function

  has_many :critics, as: :filmable, dependent: :destroy
  has_many :broadcast_professionals, dependent: :destroy
  has_many :broadcasts, through: :broadcast_professionals

  # Validations
  validates :name,
            presence: true

  # gender
  # 0: Men, 1: Women, 2: Other
  enum gender: { men: 0, women: 1, other: 2 }

  # Delegations
  delegate :name, to: :city, allow_nil: true, prefix: true
  delegate :name, to: :state, allow_nil: true, prefix: true
  delegate :name, to: :country, allow_nil: true, prefix: true
  delegate :name, to: :set_function, allow_nil: true, prefix: true

  # Callbacks
  before_save :update_address
  before_save :update_age

  # Aliases
  alias_attribute :title_str, :name
  alias_attribute :cover, :avatar
  alias_attribute :text, :title_str

  # Uploaders
  mount_uploader :avatar, ProfessionalAvatarUploader

  # Callbacks
  before_destroy :destroy_visits

  def set_functions_by_occurrence
    ordered_set_functions = FilmableProfessional
                            .where(professional_id: id)
                            .group(:set_function_id).distinct.count(:filmable_id)
                            .sort_by { |_k, value| value }
                            .reverse.to_h

    ordered_set_functions.keys
  end

  def filmography_for_set_function(set_function_filmography)
    filmable_professionals =
      FilmableProfessional
      .where(professional_id: id,
             set_function_id: set_function_filmography)
      .includes(:filmable)

    filmables = []
    filmable_professionals.each do |filmable_professional|
      filmables << filmable_professional.filmable
    end

    filmables_h = {}
    filmables.each do |filmable|
      filmables_h[filmable] = filmable.filmable_year unless filmable.blank?
    end

    # order by year
    filmables_h = filmables_h.sort_by { |_k, v| v }.reverse.to_h

    filmables_h.keys
  end

  def original_title
    original = String.new("")

    if birthday
      original << age.to_s
      original << " ("
      original << (I18n.l birthday)
      if deathday
        original << " - "
        original << (I18n.l deathday)
      end
      original << ")"
    end

    original
  end

  def release
    DateTime.now
  end

  def genders_str
    ""
  end

  def directors_str
    ""
  end

  def title_str
    name
  end

  def self.birthdays
    birthday_professionals = where("MONTH(birthday) = ? and DAY(birthday) = ?", Date.today.month, Date.today.day)
    featured_birthdays = birthday_professionals.featured(6)
    return featured_birthdays if featured_birthdays.count >= 6

    birthday_professionals.limit(6 - featured_birthdays.count) + featured_birthdays
  end

  def self.localized_genders
    genders.map { |k, _w| [human_attribute_name("gender.#{k}"), k] }
  end

  def gender_str
    return "Não informado" unless gender

    User.human_attribute_name("gender.#{gender}")
  end

  # Scopes

  def self.by_gender(gender)
    where(gender: gender)
  end

  def self.by_city(city)
    where(city: city)
  end

  def self.by_state(id)
    where(state_id: id)
  end

  def self.by_country(id)
    where(country_id: id)
  end

  # Filter

  def self.filter_by(collection, params)
    return collection unless params.present?

    result = collection
    result = result.by_gender(genders[params[:gender]]) if params[:gender].present?
    result = result.by_country(params[:country]) if params[:country].present?
    result = result.by_state(params[:state]) if params[:state].present?
    result = result.by_city(params[:city]) if params[:city].present?

    result
  end

  def tmdb_gender(tmdb)
    return 0 if tmdb == 2

    1
  end

  def api_transform(force_update = false)
    object = self

    object.update_attribute("lock_updates", false) if force_update

    unless object.lock_updates?

      tmdb_id = object.tmdb_id

      tmdb_person_url = "#{BASE_URL}/#{tmdb_id}?api_key=#{TMDB_API_KEY}&language=pt-BR"

      result = load_resource(tmdb_person_url)

      if object.birthday.blank?
        object.birthday = begin
                            Date.parse(result["birthday"])
                          rescue StandardError
                            nil
                          end
      end

      if object.deathday.blank?
        object.deathday = begin
                            Date.parse(result["deathday"])
                          rescue StandardError
                            nil
                          end
      end

      # object.gender = tmdb_gender(result["gender"])

      # object.imdb_id = result["imdb_id"]

      # object.name = result["name"]

      object.place_of_birth = result["place_of_birth"] if object.place_of_birth.blank?

      object.lock_updates = true

      object.save(validate: false)
    end

    # load_credits(object)
  rescue StandardError
    object.lock_updates = true

    object.save(validate: false)
  end

  # def load_credits(object)
  #   tmdb_id = object.tmdb_id

  #   tmdb_person_credits = "#{BASE_URL}/#{tmdb_id}/combined_credits?api_key=#{TMDB_API_KEY}"

  #   result = load_resource(tmdb_person_credits)

  #   result = result["cast"]

  #   result.each do |credit|
  #     credit_id = credit["id"]
  #     media_type = credit["media_type"]

  #     load_credit_resource(credit_id, media_type)
  #   end
  # end

  private

  # def load_credit_resource(id, media_type)
  #   resource_url = "https://api.themoviedb.org/3/#{media_type}/#{id}?api_key=#{TMDB_API_KEY}"

  #   result = load_resource(resource_url)

  #   original_title = result["original_title"]

  #   tmdb_id = result["id"]

  #   release_date = begin
  #                    Date.parse(result["release_date"])
  #                  rescue
  #                    Date.today
  #                  end
  #   year = release_date.year

  #   if media_type == "movie"
  #     by_tmdb_id = Movie.where(tmdb_id: tmdb_id)
  #     if by_tmdb_id.any?
  #       by_tmdb_id.each(&:api_transform)
  #     else
  #       ((year - 2)..(year + 2)).each do |ranged_year|
  #         on_title = Movie.search(nil, "#{original_title} (#{ranged_year})")
  #         on_title.each(&:api_transform) unless on_title.blank?
  #       end

  #       any_year = Movie.where(original_title: original_title)
  #       any_year.each(&:api_transform) unless any_year.blank?
  #     end
  #   elsif media_type == "tv"
  #     by_tmdb_id = Serie.where(tmdb_id: tmdb_id)
  #     if by_tmdb_id.any?
  #       by_tmdb_id.each(&:api_transform)
  #     else
  #       ((year - 2)..(year + 2)).each do |ranged_year|
  #         on_title = Serie.search(nil, "#{original_title} (#{ranged_year})")
  #         on_title.each(&:api_transform) unless on_title.blank?
  #       end

  #       any_year = Serie.where(original_title: original_title)
  #       any_year.each(&:api_transform) unless any_year.blank?
  #     end
  #   end
  # end

  def load_resource(url)
    url = URI(url)

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request.body = "{}"

    response = http.request(request)

    body = response.read_body

    JSON.parse(body)
  end

  def update_address
    return unless city

    self.state_id = city.state.id
    self.country_id = state.country.id
  end

  def update_age
    self.age = 0
    return unless birthday

    now = deathday.blank? ? DateTime.now.to_date : deathday
    birthday_current_year = begin
                              birthday.to_date.change(year: now.year)
                            rescue StandardError
                              birthday.to_date.change(year: now.year, day: 27)
                            end
    self.age = now.year - birthday.year - (birthday_current_year > now ? 1 : 0)
  end

  def self.featured(limit = 15)
    ids = Visit.where(action: 'show').where("controller like ?", "%professionals%").pluck(:resource_id)

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
