//= require datepicker_custom

$(function() {
  'use strict';

  // Initialize datepickers
  $('input.datepicker').datepicker();

  // When add a field, datepicker is initialized
  $('form').on('cocoon:after-insert', function(e, insertedItem) {
    insertedItem.find('input.datepicker').datepicker();
  });

  $('form').on('change', "[data-cep] input", function (event){
    var self = $(this),
        cepValue = self.val(),
        dataCEP = self.closest('[data-cep]'),
        path = dataCEP.data('path'),
        attrs = { cep: cepValue };

    var attrs = {
      cep: cepValue
    };

    $.ajax({
      url: path,
      type: "GET",
      data: attrs,
      success: function(data) {
        if(data.status == "ok") {
          // alert(data.data.cidade + "/" + data.data.uf);

          $("#user_address").val(data.data.tipo_logradouro + " " + data.data.logradouro);
          $("#user_number").val("");
          $("#user_neighbourhood").val(data.data.bairro);

          var uf = data.data.uf;

          $('#user_state_id option').
            filter(function() { return $.trim( $(this).text() ) == uf; }).
            attr('selected',true);

          var city = data.data.cidade;

          var state_attrs = {
            acronym: uf
          };

          $.ajax({
            url: "/api/v1/cities",
            type: "GET",
            data: state_attrs,
            success: function(d) {
              var cities = $("#user_city_id");

              cities.html('');
              cities.append(new Option("Município", ""));
              for(var i = 0; i < d.length; i++) {
                cities.append(new Option(d[i].name, d[i].id));
              }

              $('#user_city_id option').
                filter(function() { return $.trim( $(this).text() ) == city; }).
                attr('selected',true);

              $("#search-cep-status").html("");

            },
            error: function(data) {
              console.log("Não achou as cidades!!");
            }
          });


        } else {
          console.log("Não achou o CEP!!");
        }
      },
      error: function(data) {
        console.log("erro ao buscar CEP!");
      }
    });
    event.stopPropagation();
  });

});
