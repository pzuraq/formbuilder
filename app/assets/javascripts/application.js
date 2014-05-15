// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery/dist/jquery
//= require jquery-ujs/src/rails
//= require turbolinks
//= require bootstrap/dist/js/bootstrap
//= require knockout/dist/knockout
//= require knockout-validation/Dist/knockout.validation
//= require_tree .

ko.validation.configure({
    registerExtenders: true,
    messagesOnModified: true,
    insertMessages: true,
    parseInputAttributes: true,
    messageTemplate: null
});

var viewModel = {}

$(function () {
  $('.section').each(function(index) {
    var properties = {};

    $(this).children('input').each(function() {
      binding = $(this).data('bind').split(/[,.:]/);

      properties[binding[2]] = ko.observable();
    });

    viewModel['section'+(index+1)] = ko.validatedObservable(properties);
  })


  viewModel.errors = ko.validation.group(viewModel);

  ko.applyBindings(viewModel);

});
