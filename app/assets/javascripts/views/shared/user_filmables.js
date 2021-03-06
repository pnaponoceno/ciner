function UserFilmables() {
  'use strict';

  // globals

  var self = this;

  // public

  self.bindUserFilmables = function(aContainer) {
    _bindUserFilmables(aContainer);
  };

  function _bindUserFilmables(aContainer) {
    var dataUserFilmables = aContainer.find('[data-user-action]');

    $(dataUserFilmables).on('click', '[data-action]', function() {
      var self = $(this);

      if (!self.data('unlocked')) {
        $('#actionLockedModal').modal('show');
      }
      else {
        var parent = self.closest('[data-user-action]'),
            url = parent.data("url"),
            user_id = parent.data("user-id"),
            filmable_id = parent.data("filmable-id"),
            filmable_type = parent.data("filmable-type"),
            user_action = self.data("action"),
            data = {
              user_id: user_id,
              filmable_id: filmable_id,
              filmable_type: filmable_type,
              user_action: user_action
          };

        _action(parent, url, data, self);
      }
    });

    $(dataUserFilmables).on('click', '[data-collection]', function() {
      var self = $(this),
          url = self.data('url'),
          a = self.find('a'),
          parent = self.closest('[data-user-action]'),
          user_id = parent.data('user-id'),
          filmable_id = parent.data('filmable-id'),
          filmable_type = parent.data('filmable-type');

      var data = {
            user_id: user_id,
            filmable_id: filmable_id,
            filmable_type: filmable_type
          }

      $.ajax({
        type: 'GET',
        dataType: 'html',
        url: url,
        data: data,
        success: function(data) {
          $('#collectionModal .modal-dialog').html(data);
          $('#collectionModal input.datepicker').mask('99/99/9999');
          $('#collectionModal').modal('show');
        }
      });
    });

    $('#collectionModal').on('click', '[data-collect]', function() {
      var self = $(this),
          parentModal = self.closest('.modal'),
          mediaSelect = parentModal.find('#media'),
          user_id = parentModal.data('user-id'),
          filmable_id = parentModal.data('filmable-id'),
          filmable_type = parentModal.data('filmable-type'),
          user_action = parentModal.data('action'),
          url = parentModal.data('url'),
          mediaValue = mediaSelect.val(),
          versionSelect = parentModal.find('#version'),
          versionValue = versionSelect.val(),
          positionField = parentModal.find("#position"),
          positionValue = positionField.val(),
          store = parentModal.find("#store").val(),
          price = parentModal.find("#price").val(),
          gift = parentModal.find("#gift").prop('checked'),
          bought = parentModal.find("#bought").val(),
          isbn = parentModal.find("#isbn").val(),
          borrowed = parentModal.find('#borrowed').val(),
          observation = parentModal.find('#observation').val(),
          box = parentModal.find("#box").prop('checked'),
          box_title = parentModal.find('#box_title').val(),
          data = {
            user_id: user_id,
            filmable_id: filmable_id,
            filmable_type: filmable_type,
            user_action: user_action,
            media: mediaValue,
            version: versionValue,
            position: positionValue,
            store: store,
            price: price,
            gift: gift,
            bought: bought,
            isbn: isbn,
            borrowed: borrowed,
            observation: observation,
            box: box,
            box_title: box_title
          };

      _action($('[data-user-action]'), url, data, $('[data-collection]'));

      $('#collectionModal').modal('hide');
    });

    $(dataUserFilmables).on('click', '[data-recommend]', function() {
      $('#recommendModal').modal('show');
    });

    $(document).on('click', '[data-recommend-to]', function() {
      var self = $(this),
          select = $('#user_ids')[0],
          selectedUsers = _getSelectValues(select),
          parent = $('#user-actions').find('[data-user-action]'),
          url = parent.data("url"),
          user_id = parent.data("user-id"),
          filmable_id = parent.data("filmable-id"),
          filmable_type = parent.data("filmable-type"),
          user_action = self.data("action"),
          data = {
            user_id: user_id,
            filmable_id: filmable_id,
            filmable_type: filmable_type,
            user_ids: selectedUsers,
            user_action: user_action
          };

        toastr.info("Seus amigos vão adorar a indicação!");
        $('.modal').modal('hide');
        _action(parent, url, data, self);
    });
  }

  function _getSelectValues(aSelect) {
    var result = [];
    var options = aSelect && aSelect.options;
    var opt;

    for (var i=0, iLen=options.length; i<iLen; i++) {
      opt = options[i];

      if (opt.selected) {
        result.push(opt.value || opt.text);
      }
    }
    return result;
  }

  function _action(aParent, aUrl, aData, aButton) {
    $.ajax({
      type: 'PUT',
      dataType: 'JSON',
      data: aData,
      url: aUrl,
      beforeSend: function(xhr) { xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')) },
      success: function(data) {
        _updateUserFilmables(aParent, data, aButton);
        _updateCounters(aParent, data);
      }
    });
  }

  function _updateUserFilmables(aParent, aData, aButton) {
    var classToAdd = aData.result_class;

    if (aButton.data("action") == "want_to_see" && classToAdd == "active") {
      aParent.find("[data-action='watched'] a").removeClass('active');
    }

    if (aButton.data("action") == "watched" && classToAdd == "active") {
      aParent.find("[data-action='want_to_see'] a").removeClass('active');
    }

    aButton.find('a').removeClass('active');
    aButton.find('a').addClass(classToAdd);
  }

  function _updateCounters(aParent, aData) {
    var watched_str = aData.watched_str,
        want_to_see_str = aData.want_to_see_str,
        collection_str = aData.collection_str,
        favorite_str = aData.favorite_str,
        recommend_str = aData.recommend_str;

    aParent.find("[data-action='watched'] [data-count]").html(watched_str);
    aParent.find("[data-action='want_to_see'] [data-count]").html(want_to_see_str);
    aParent.find("[data-collection='collection'] [data-count]").html(collection_str);
    aParent.find("[data-action='favorite'] [data-count]").html(favorite_str);
    aParent.find("[data-recommend='like'] [data-count]").html(recommend_str);
  }
};
