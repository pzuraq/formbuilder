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

ko.bindingHandlers.fadeVisible = {
  init: function(element, valueAccessor) {
    // Initially set the element to be instantly visible/hidden depending on the value
    var value = valueAccessor();
    $(element).toggle(ko.unwrap(value)); // Use "unwrapObservable" so we can handle values that may or may not be observable
  },
  update: function(element, valueAccessor) {
    // Whenever the value subsequently changes, slowly fade the element in or out
    var value = valueAccessor();
    ko.unwrap(value) ? $(element).fadeIn() : $(element).fadeOut();
  }
};

var viewModel = {}

$(function () {
  $('.section').each(function(index) {
    var selector = $(this);

    var section = function() {
      var self = this;

      self._display = ko.observable(false);
      self._nextSection = selector.data('next');
      self.properties = [];

      selector.children('input').each(function() {
        var binding = $(this).data('bind').split(/[,.:]/),
            property = binding[2];


        self[property] = ko.observable();
        self.properties.push(property);
      });

      self.setDisplay = ko.computed(function() {
        var next = viewModel[self._nextSection] ? viewModel[self._nextSection]() : null;

        $.each(self.properties, function(index, prop) {
          self[prop]();
        });

        if(next) {
          if (self.isValid && self.isValid()) {
            next._display(true)
          } else {
            $.each(next.properties, function(index, prop) {
              next[prop](null);
            });

            next._display(false);
          }
        }
      });
    };

    var otherProps = {};

    viewModel[selector.attr('id')] = ko.validatedObservable(new section());
  })

  viewModel.section1()._display(true);

  viewModel.errors = ko.validation.group(viewModel);

  ko.applyBindings(viewModel);

});
