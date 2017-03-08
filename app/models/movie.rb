require 'HTTParty'
require 'Nokogiri'

# frozen_string_literal: true
class Movie < ActiveRecord::Base
  include Searchables::Movie
  include FilmProfitable

  # Associations
  belongs_to :city
  belongs_to :state
  belongs_to :country
  belongs_to :age_range

  belongs_to :studio

  has_many :critics, as: :filmable
  has_many :filmable_professionals, as: :filmable
  has_many :professionals, through: :filmable_professionals

  # Uploaders
  mount_uploader :cover, CoverUploader

  # Validations
  validates :original_title,
            :year,
            :length,
            presence: true

  # Delegations
  delegate :name, to: :city, allow_nil: true, prefix: true
  delegate :name, to: :state, allow_nil: true, prefix: true
  delegate :name, to: :country, allow_nil: true, prefix: true
  delegate :name, to: :age_range, allow_nil: true, prefix: true

  # Aliases
  alias_attribute :text, :title_str

  # Scopes

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
    result = result.by_country(params[:country]) if params[:country].present?
    result = result.by_state(params[:state]) if params[:state].present?
    result = result.by_city(params[:city]) if params[:city].present?

    result
  end

  # API

  def api_transform
    object = self
    title = object.original_title

    title_str = title[0, title.length - 6].gsub(/\P{ASCII}/, '').delete("#")
    year_str = title[title.length - 5, 4]

    url = "http://www.omdbapi.com/?t=#{title_str}&y=#{year_str}&plot=short&r=json"

    uri = URI.parse(url)

    if uri.is_a?(URI::HTTP)
      begin
        response = HTTParty.get(url)

        response = response.parsed_response

        response_status = response["Response"]

        if response_status == "True"
          omdb_title = response["Title"]

          omdb_year = response["Year"]

          omdb_rated = response["Rated"]

          omdb_released = begin
                            Date.parse(response["Released"])
                          rescue
                            nil
                          end

          omdb_runtime = response["Runtime"]

          omdb_genre = response["Genre"]

          omdb_directors = response["Director"]

          omdb_writers = response["Writer"]

          omdb_actors = response["Actors"]

          omdb_plot = response["Plot"]

          omdb_genre = response["Genre"]

          # EasyTranslate.translate(omdb_plot, :to => 'pt', :key => "AIzaSyD66z0ODjU0B65NUYZiTD-hwyQVgdCfu6Y")

          # response["Language"]

          omdb_country = response["Country"]

          # response["Awards"]

          omdb_poster = response["Poster"]

          # response["Metascore"]

          # response["imdbRating"]

          # response["imdbVotes"]

          omdb_id = response["imdbID"]

          # response["Type"]

          # response["Response"]

          # object.original_title = omdb_title
          object.title = omdb_title
          object.year = omdb_year

          object.release = omdb_released if omdb_released

          object.length = omdb_runtime
          object.synopsis = omdb_plot

          object.omdb_rated = omdb_rated

          object.omdb_directors = omdb_directors

          object.omdb_writers = omdb_writers

          object.omdb_actors = omdb_actors

          object.omdb_genre = omdb_genre

          object.omdb_id = omdb_id

          if omdb_poster && !omdb_poster.empty? && omdb_poster != "N/A" && omdb_poster
            cover = open(omdb_poster)

            begin
              object.cover = cover if cover
            rescue
            end
          end

          page = HTTParty.get("http://www.imdb.com/title/#{omdb_id}/releaseinfo")

          parsed_page = Nokogiri::HTML(page)

          odd_rows = parsed_page.css('.subpage_data.spFirst').css('.odd')
          even_rows = parsed_page.css('.subpage_data.spFirst').css('.even')

          rows = odd_rows + even_rows

          rows.each do |row|
            if row.text.include? "Brazil"
              byebug
              omdb_brazilian_release = nil
              array = row.text.split("\n").map(&:strip)
              array.delete("")
              array.delete("Brazil")
              array.each do |element|
                omdb_brazilian_release = begin
                                          Date.parse(element)
                                         rescue
                                          nil
                                         end
                break if omdb_brazilian_release
              end
              object.brazilian_release = omdb_brazilian_release if omdb_brazilian_release
            end
          end

          odd_rows = parsed_page.css('.subpage_data.spEven2Col').css('.odd')
          even_rows = parsed_page.css('.subpage_data.spEven2Col').css('.even')

          rows = odd_rows + even_rows

          rows.each do |row|
            if row.text.include? "Brazil"
              omdb_brazilian_title = nil
              array = row.text.split("\n").map(&:strip)
              array.delete("")
              array.delete("Brazil")
              omdb_brazilian_title = array[0] unless array.empty?
              object.title = omdb_brazilian_title if omdb_brazilian_title
            end
          end

          object.original_title = omdb_title

          object.save(validate: false)
        end
      rescue
      end
    end
  end
end
