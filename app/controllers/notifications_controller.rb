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
    notification_sender_id = params[:sender_id]
    notification_receiver_id = params[:receiver_id]

    on_create_friend_request(notification_sender_id, notification_receiver_id) if notification_type == 'create_friend_request'

    on_cancel_friend_request(notification_sender_id, notification_receiver_id) if notification_type == 'cancel_friend_request'

    on_accept_friend_request(notification_sender_id, notification_receiver_id) if notification_type == 'accept_friend_request'

    on_decline_friend_request(notification_sender_id, notification_receiver_id) if notification_type == 'decline_friend_request'

    on_remove_friend(notification_sender_id, notification_receiver_id) if notification_type == 'remove_friend'
  end

  # Friendship
  def on_create_friend_request(sender_id, receiver_id)
    notification_sender = User.find(sender_id)

    if Notification.create(sender_id: sender_id, receiver_id: receiver_id, notification_type: :friend_request, answer: :waiting)
      render json: { text: 'Aguardando',
                     next_action: 'cancel_friend_request' }
    end
  end

  def on_cancel_friend_request(sender_id, receiver_id)
    notification = Notification.find_by(sender_id: sender_id, receiver_id: receiver_id, notification_type: :friend_request)
    notification.destroy

    render json: { text: 'Adicionar amigo',
                   next_action: 'create_friend_request' }
  end

  def on_remove_friend(sender_id, receiver_id)
    notification = Notification.find_by(sender_id: receiver_id, receiver_id: sender_id, notification_type: :friend_request, answer: :approved)
    notification.destroy unless notification.blank?

    notification = Notification.find_by(sender_id: sender_id, receiver_id: receiver_id, notification_type: :friend_request, answer: :approved)
    notification.destroy unless notification.blank?

    notification = Notification.find_by(sender_id: sender_id, receiver_id: receiver_id, notification_type: :accept_friend_request)
    notification.destroy unless notification.blank?

    notification = Notification.find_by(sender_id: receiver_id, receiver_id: sender_id, notification_type: :accept_friend_request)
    notification.destroy unless notification.blank?

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
    notification.destroy unless notification.blank?

    notification = Notification.find_by(sender_id: sender_id, receiver_id: receiver_id, notification_type: :friend_request)
    notification.destroy unless notification.blank?
  end

  # Filtering

  def paginated_notifications
    notifications.page(params[:page]).per(PER_PAGE)
  end
end