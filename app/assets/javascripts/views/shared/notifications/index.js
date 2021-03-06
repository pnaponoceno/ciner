$(document).ready(function() {
  $('[data-friendship-action]').on('click', 'button.btn.btn-login', function() {
    var self = $(this),
        friendship = self.closest('[data-friendship-action]'),
        sender_id = friendship.data('friendshipSenderId'),
        receiver_id = friendship.data('friendshipReceiverId'),
        notification_id = friendship.data('friendshipNotificationId'),
        message = friendship.data('friendshipMessage'),
        notification_type = friendship.attr('data-friendship-action'),
        url = friendship.data('friendshipUrl'),
        button = friendship.find('span.text');

    data = {
      sender_id: sender_id,
      receiver_id: receiver_id,
      notification_type: notification_type,
      notification_id: notification_id,
      message: message
    }

    _action(friendship, url, data, button);
  });

  function _action(aParent, aUrl, aData, aButton) {
    $.ajax({
      type: 'POST',
      dataType: 'JSON',
      data: aData,
      url: aUrl,
      beforeSend: function(xhr) { xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')) },
      success: function(data) {
        var notificationBox = aParent.closest('.notification-box');

        notificationBox.fadeOut(500, function(){ $(this).remove();});
      }
    });
  }
});
