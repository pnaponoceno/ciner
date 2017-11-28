function Reactions() {
  'use strict';

  // globals

  var self = this;

  // public

  self.bindReactions = function(aContainer) {
    _bindReactions(aContainer);
  };

  function _bindReactions(aContainer) {
    var dataReactions = aContainer.find('[data-reactions]');

    $(dataReactions).on('click', '[data-vote]', function() {
      var self = $(this),
          parent = self.closest('[data-reactions]'),
          url = self.data("url");

      _react(parent, url);
    });

    $(dataReactions).on('click', '[data-delate]', function() {
      var self = $(this),
          parent = self.closest('[data-reactions]'),
          url = self.data("url"),
          location = document.URL,
          userId = self.data("user-id"),
          data = {
            delate: {
              location: location,
              user_id: userId
            }
          }

      _delate(parent, url, data);
    });
  }

  function _delate(aParent, aUrl, aData) {
    $.ajax({
      type: 'POST',
      dataType: 'JSON',
      url: aUrl,
      data: aData,
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      success: function(data) {
        toastr.info("Agradecemos pela denúncia! Assim, você ajuda a tornar o Ciner melhor!");
      }
    });
  }

  function _react(aParent, aUrl) {
    $.ajax({
      type: 'PUT',
      dataType: 'JSON',
      url: aUrl,
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      success: function(data) {
        _updateReactions(aParent, data);
      }
    });
  }

  function _updateReactions(aParent, aData) {
    var dislikeCount = aData.dislike_count,
        likeCount = aData.like_count,
        likeIconClass = aData.like_icon,
        dislikeIconClass = aData.dislike_icon;

    _updateReaction(aParent, '[data-like-counter]', '[data-like-icon]', likeCount, likeIconClass);
    _updateReaction(aParent, '[data-dislike-counter]', '[data-dislike-icon]', dislikeCount, dislikeIconClass);
  }

  function _updateReaction(aParent, aCounterId, aIconId, aCount, aIconClass) {
    aParent.find(aCounterId).html(aCount);
    aParent.find(aIconId).removeClass();
    aParent.find(aIconId).addClass(aIconClass);
  }
};
