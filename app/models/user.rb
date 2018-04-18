# frozen_string_literal: true

class User < ActiveRecord::Base
  include Searchables::User

  acts_as_paranoid
  acts_as_voter

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable, omniauth_providers: %i[facebook]

  # Uploaders
  mount_uploader :avatar, UserAvatarUploader
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update :crop_avatar

  def crop_avatar
    avatar.recreate_versions! if crop_x.present?
  end

  # Associations
  belongs_to :city
  belongs_to :state
  belongs_to :country

  has_many :critics, dependent: :destroy
  has_many :user_filmables, dependent: :destroy
  has_many :user_filmable_ratings, dependent: :destroy
  has_many :user_trophies, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_one :curriculum, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :user_trophies, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :trophies, through: :user_trophies

  # Validations
  validates :email,
            :name,
            :birthday,
            :gender,
            :role,
            :nickname,
            :terms_of_use,
            presence: true

  validates_uniqueness_of :nickname, :email, conditions: -> { where(deleted_at: nil) }
  validates_uniqueness_of :cpf, allow_blank: true, allow_nil: true

  validates_presence_of :password_confirmation, on: :create

  # Enums

  # role
  # 0: Admin
  # 1: Ciner Free / 2: Ciner Pro / 3: Ciner Clássico / 4: Ciner Cult
  enum role: { admin: 0, free: 1, pro: 2, classic: 3, cult: 4 }

  # gender
  # 0: Men, 1: Women, 2: Other
  enum gender: { men: 0, women: 1, other: 2 }

  enum collection_privacy: { global: 0, only_friends: 1, only_me: 2 }

  # Delegations
  delegate :name, to: :city, allow_nil: true, prefix: true
  delegate :name, to: :state, allow_nil: true, prefix: true
  delegate :acronym, to: :state, allow_nil: true, prefix: true
  delegate :name, to: :country, allow_nil: true, prefix: true

  # Callbacks
  before_save :update_address
  before_save :update_age

  # after_create :send_welcome_mail
  after_create :grant_welcome_trophy

  before_destroy :destroy_notifications

  # Aliases
  alias_attribute :text, :name
  alias_attribute :title_str, :name
  alias_attribute :cover, :avatar

  def self.from_omniauth(auth)
    if user = User.find_by(provider: auth.provider, uid: auth.uid)
      user
    elsif user = User.find_by(email: auth.info.email, provider: nil, uid: nil)
      user.tap { |u| u.update(provider: auth.provider, uid: auth.uid, email: auth.info.email) }
    else
      User.new
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.localized_roles
    roles.map { |k, _w| [human_attribute_name("role.#{k}"), k] }
  end

  def self.localized_collection_privacies
    collection_privacies.map { |k, _w| [human_attribute_name("collection_privacy.#{k}"), k] }
  end

  def self.localized_genders
    genders.map { |k, _w| [human_attribute_name("gender.#{k}"), k] }
  end

  def create_trophies(type)
    if type == "collection"
      collection_number = user_filmables.collection.count
      if collection_number == 25 # 25
        current_trophy = Trophy.find_by(name: 'O colecionador 1')
      elsif collection_number == 100 # 100
        current_trophy = Trophy.find_by(name: 'O colecionador 2')
      elsif collection_number == 250 # 250
        current_trophy = Trophy.find_by(name: 'O colecionador 3')
      elsif collection_number == 500 # 500
        current_trophy = Trophy.find_by(name: 'O colecionador 4')
      end
    elsif type == "watched"
      watched_number = user_filmables.watched.count
      if watched_number == 100 # 100
        current_trophy = Trophy.find_by(name: 'Essa é minha vida 1')
      elsif watched_number == 250 # 250
        current_trophy = Trophy.find_by(name: 'Essa é minha vida 2')
      elsif watched_number == 1000 # 1000
        current_trophy = Trophy.find_by(name: 'Essa é minha vida 3')
      elsif watched_number == 2000 # 2000
        current_trophy = Trophy.find_by(name: 'Essa é minha vida 4')
      end
    elsif type == "friends"
      friends_number = friends.count
      if friends_number == 10 # 10
        current_trophy = Trophy.find_by(name: 'Ciner Sociável 1')
      elsif friends_number == 25 # 25
        current_trophy = Trophy.find_by(name: 'Ciner Sociável 2')
      elsif friends_number == 50 # 50
        current_trophy = Trophy.find_by(name: 'Ciner Sociável 3')
      elsif friends_number == 100 # 100
        current_trophy = Trophy.find_by(name: 'Ciner Sociável 4')
      end
    end
    current_trophy ||= nil
    if current_trophy
      user_trophy = UserTrophy.find_or_create_by(user: self, trophy: current_trophy)
      user_trophy.notify_user
    end

    create_watched_specific if type == "watched"
  end

  def create_watched_specific
    # How I Met Your Mother
    watched_filmable = user_filmables.where(filmable_id: "1033707", filmable_type: "Serie").first
    if watched_filmable
      current_trophy = Trophy.find_by(name: 'Como eu conheci o CINER')
      user_trophy = UserTrophy.find_or_create_by(user: self, trophy: current_trophy)
      user_trophy.notify_user
    end

    # Friends
    watched_filmable = user_filmables.where(filmable_id: "827259", filmable_type: "Serie").first
    if watched_filmable
      current_trophy = Trophy.find_by(name: 'Aquele do CINER')
      user_trophy = UserTrophy.find_or_create_by(user: self, trophy: current_trophy)
      user_trophy.notify_user
    end

    founders = [3275988, 3023822, 3459423, 3077677, 3000717, 3280398, 3059311,
                3222511, 3203942, 2946886, 3866625, 4069360, 4069359, 2979000,
                2912143, 2916904, 3747559, 3435383, 3858438, 3392276, 2800244,
                3621042, 3776188, 3560971, 2772816, 3844068, 3905769, 3550326,
                3278525, 2956856, 3055532, 3801952, 3151455, 2832558, 3727226,
                3665905, 2877140, 2877147, 2877149, 2770528, 2837895, 3190164,
                3612872, 3116749, 2770603, 3168241, 3533732, 3689603, 2858240,
                2887859, 3027047, 3018459]
    watched_filmable =
      user_filmables.where(
        filmable_id: founders)
    if watched_filmable.count == founders.count
      current_trophy = Trophy.find_by(name: 'Secreto')
      user_trophy = UserTrophy.find_or_create_by(user: self, trophy: current_trophy)
      user_trophy.notify_user
    end

    programmer = [3275988, 3023822, 3459423, 3077677, 3000717, 3280398, 3059311,
                  3222511, 3203942, 2946886]
    watched_filmable =
      user_filmables.where(
        filmable_id: programmer)
    if watched_filmable.count == programmer.count
      current_trophy = Trophy.find_by(name: 'Programe-se')
      user_trophy = UserTrophy.find_or_create_by(user: self, trophy: current_trophy)
      user_trophy.notify_user
    end
  end

  def notifications
    Notification.where(receiver_id: id)
  end

  def ciner_productions
    productions = []
    CinerProduction.where(user_id: id).pluck(:id).each do |ciner_production_id|
      productions << ciner_production_id
    end
    CinerProductionProfessional.where(user_id: id).pluck(:ciner_production_id).each do |ciner_production_id|
      productions << ciner_production_id
    end
    CinerProduction.approved.where(id: productions.uniq)
  end

  def friends
    ids = []
    Notification
      .where(sender_id: id, notification_type: :friend_request,
             answer: :approved).pluck(:receiver_id).each do |friend_id|
      ids << friend_id
    end
    Notification
      .where(receiver_id: id, notification_type: :friend_request,
             answer: :approved).pluck(:sender_id).each do |friend_id|
      ids << friend_id
    end
    User.where(id: ids.uniq)
  end

  def registered_at_str
    return "Não informado" unless registered_at
    I18n.localize(registered_at)
  end

  def gender_str
    return "Não informado" unless gender
    User.human_attribute_name("gender.#{gender}")
  end

  def role_str
    return "Não informado" unless role
    User.human_attribute_name("role.#{role}")
  end

  def nickname_str
    return name if nickname.blank? && !admin?
    return "#{name} (CINER)" if nickname.blank? && admin?
    return "#{nickname} (CINER)" if admin?
    nickname
  end

  # Scopes

  def self.birthdays
    where("MONTH(birthday) = ? and DAY(birthday) = ?", Date.today.month, Date.today.day)
  end

  def self.by_gender(gender)
    where(gender: gender)
  end

  def self.by_role(role)
    where(role: role)
  end

  def self.by_city(city)
    where(city: city)
  end

  def self.by_state(id)
    where(state_id: id)
  end

  def self.filter_by(collection, params)
    return collection unless params.present?

    result = collection
    result = result.by_gender(genders[params[:gender]]) if params[:gender].present?
    result = result.by_role(roles[params[:role]]) if params[:role].present?
    result = result.by_state(params[:state]) if params[:state].present?
    result = result.by_city(params[:city]) if params[:city].present?

    result
  end

  def user_collection
    UserFilmable.includes(:filmable).collection.where(user: self).order(position: :asc)
  end

  def user_favorite
    filmables = []

    UserFilmable.includes(:filmable).favorite.where(user: self).each do |user_filmable|
      filmables << user_filmable.filmable
    end

    filmables
  end

  def user_watched
    filmables = []

    UserFilmable.includes(:filmable).watched.where(user: self).each do |user_filmable|
      filmables << user_filmable.filmable
    end

    filmables
  end

  def user_want_to_see
    filmables = []

    UserFilmable.includes(:filmable).want_to_see.where(user: self).each do |user_filmable|
      filmables << user_filmable.filmable
    end

    filmables
  end

  def simple_address
    return "" unless city || state
    return "#{city_name} - #{state_name}" if city && state
    return city_name if city
    state_name if state
  end

  def trophy_count
    1
  end

  private

  # before_save
  def update_address
    return unless city
    self.state_id = city.state.id
    self.country_id = state.country.id
  end

  # before_save
  def update_age
    self.age = 0 unless birthday
    now = Time.now.utc.to_date
    self.age =
      now.year - birthday.year - (birthday.to_date.change(year: now.year) > now ? 1 : 0)
  end

  # after_create
  def send_welcome_mail
    SignupMailer.welcome_mail(email).deliver_now
  end

  # after_create
  def grant_welcome_trophy
    current_trophy = Trophy.find_by(name: 'Ciner com orgulho')
    user_trophy =
      UserTrophy.find_or_create_by(
        user: self,
        trophy: current_trophy
      )
    user_trophy.notify_user
  end

  # before_destroy
  def destroy_notifications
    Notification.where(receiver_id: id).destroy_all
    Notification.where(sender_id: id).destroy_all
  end
end
