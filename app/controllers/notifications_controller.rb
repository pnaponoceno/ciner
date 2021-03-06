# frozen_string_literal: true

class NotificationsController < ApplicationController
  include NotificationsBreadcrumb

  respond_to :html, :js

  # exposes
  expose(:notifications) { Notification.empty }

  def index
    self.notifications = paginated_notifications
  end

  def create
    type_based_create(params)
  end

  private

  def type_based_create(params)
    notification_type = params[:notification_type]
    notification_sender_id = params[:sender_id] || :system
    notification_receiver_id = params[:receiver_id]
    notification_id = params[:notification_id] || nil
    notification_message = params[:message] || nil

    on_create_delate_checked(notification_sender_id, notification_receiver_id) if notification_type == 'delate_ok'

    if notification_type == 'create_friend_request'
      on_create_friend_request(notification_sender_id, notification_receiver_id)
    end

    if notification_type == 'cancel_friend_request'
      on_cancel_friend_request(notification_sender_id, notification_receiver_id)
    end

    if notification_type == 'accept_friend_request'
      on_accept_friend_request(notification_sender_id, notification_receiver_id)
    end

    if notification_type == 'decline_friend_request'
      on_decline_friend_request(notification_sender_id, notification_receiver_id)
    end

    on_remove_friend(notification_sender_id, notification_receiver_id) if notification_type == 'remove_friend'

    on_contact_professional(notification_sender_id, notification_receiver_id) if notification_type == 'contact'

    on_accept_contact(notification_sender_id, notification_receiver_id) if notification_type == "accept_contact"

    on_decline_contact(notification_sender_id, notification_receiver_id) if notification_type == "decline_contact"

    on_accept_ciner_production(notification_sender_id, notification_receiver_id, notification_message, notification_id) if notification_type == "accept_ciner_production"

    on_decline_ciner_production(notification_sender_id, notification_receiver_id, notification_message, notification_id) if notification_type == "decline_ciner_production"
  end

  def on_accept_ciner_production(sender_id, receiver_id, message, notification_id)
    notification = Notification.find_by(id: notification_id, sender_id: receiver_id, receiver_id: sender_id, notification_type: :ciner_production_pending, message: message)
    notification.update_attributes(answer: :no_answer) unless notification.blank?

    CinerProduction.unscoped.find(notification.message.to_i).update_attribute("status", "approved")

    notification = Notification.create(sender_id: sender_id, receiver_id: receiver_id, notification_type: :ciner_production_approved, answer: :no_answer, message: notification.message.to_i)
    render json: { status: 'ok' } if notification.save
  end

  def on_decline_ciner_production(sender_id, receiver_id, message, notification_id)
    notification = Notification.find_by(id: notification_id, sender_id: receiver_id, receiver_id: sender_id, notification_type: :ciner_production_pending, message: message)
    notification.update_attributes(answer: :no_answer) unless notification.blank?

    CinerProduction.unscoped.find(notification.message.to_i).update_attribute("status", "reproved")

    notification = Notification.create(sender_id: sender_id, receiver_id: receiver_id, notification_type: :ciner_production_reproved, answer: :no_answer, message: notification.message.to_i)
    render json: { status: 'ok' } if notification.save
  end

  # Contact professional
  def on_contact_professional(sender_id, receiver_id)
    notification = Notification.create(sender_id: sender_id, receiver_id: receiver_id, notification_type: :contact, answer: :waiting)
    render json: { status: 'ok' } if notification.save
  end

  # Delate ok
  def on_create_delate_checked(_sender_id, receiver_id)
    notification = Notification.create(receiver_id: receiver_id, notification_type: :delate_ok, answer: :no_answer)
    render json: { status: 'ok' } if notification.save
  end

  # Friendship
  def on_create_friend_request(sender_id, receiver_id)
    notification_sender = User.find(sender_id)

    notification = Notification.find_or_create_by(sender_id: sender_id, receiver_id: receiver_id, notification_type: :friend_request, answer: :waiting)
    if notification.save
      render json: { text: 'Aguardando',
                     next_action: 'cancel_friend_request' }
    end
  end

  def on_cancel_friend_request(sender_id, receiver_id)
    notification = Notification.find_by(sender_id: sender_id, receiver_id: receiver_id, notification_type: :friend_request)
    notification.update_attributes(answer: :no_answer)

    render json: { text: 'Adicionar amigo',
                   next_action: 'create_friend_request' }
  end

  def on_remove_friend(sender_id, receiver_id)
    notification = Notification.find_by(sender_id: receiver_id, receiver_id: sender_id, notification_type: :friend_request, answer: :approved)
    notification.update_attributes(answer: :no_answer) unless notification.blank?

    notification = Notification.find_by(sender_id: sender_id, receiver_id: receiver_id, notification_type: :friend_request, answer: :approved)
    notification.update_attributes(answer: :no_answer) unless notification.blank?

    notification = Notification.find_by(sender_id: sender_id, receiver_id: receiver_id, notification_type: :accept_friend_request)
    notification.update_attributes(answer: :no_answer) unless notification.blank?

    notification = Notification.find_by(sender_id: receiver_id, receiver_id: sender_id, notification_type: :accept_friend_request)
    notification.update_attributes(answer: :no_answer) unless notification.blank?

    render json: { text: 'Adicionar amigo',
                   next_action: 'create_friend_request' }
  end

  def on_accept_friend_request(sender_id, receiver_id)
    notification_sender = User.find(sender_id)
    notification = Notification.find_by(sender_id: receiver_id, receiver_id: sender_id, notification_type: :friend_request)
    notification.update_attributes(answer: :approved)

    Notification.create(
      sender_id: sender_id,
      receiver_id: receiver_id,
      notification_type: :accept_friend_request
    )
  end

  def on_decline_friend_request(sender_id, receiver_id)
    notification = Notification.find_by(sender_id: receiver_id, receiver_id: sender_id, notification_type: :friend_request)
    notification.update_attributes(answer: :no_answer) unless notification.blank?

    notification = Notification.find_by(sender_id: sender_id, receiver_id: receiver_id, notification_type: :friend_request)
    notification.update_attributes(answer: :no_answer) unless notification.blank?
  end

  def on_accept_contact(sender_id, receiver_id)
    notification = Notification.find_by(sender_id: receiver_id, receiver_id: sender_id, notification_type: :contact)
    notification.update_attributes(answer: :no_answer) unless notification.blank?

    notification = Notification.create(sender_id: sender_id, receiver_id: receiver_id, notification_type: :accept_contact, answer: :no_answer)
    render json: { status: 'ok' } if notification.save
  end

  def on_decline_contact(sender_id, receiver_id)
    notification = Notification.find_by(sender_id: receiver_id, receiver_id: sender_id, notification_type: :contact)
    notification.update_attributes(answer: :no_answer) unless notification.blank?
  end

  # Filtering

  def paginated_notifications
    notifications.page(params[:page]).per(PER_PAGE)
  end
end
