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
    var value = ko.unwrap(valueAccessor());
    $(element).toggle(value); // Use "unwrapObservable" so we can handle values that may or may not be observable
  },
  update: function(element, valueAccessor) {
    // Whenever the value subsequently changes, slowly fade the element in or out
    var value = ko.unwrap(valueAccessor());
    value ? $('.section').promise().then(function() {
       $(element).fadeIn()
    }) : $(element).fadeOut();
  }
};

var viewModel = {}

$(function () {
  $('.section').each(function(index) {
    var selector = $(this);

    var section = function() {
      var self = this;

      self.isValid = ko.observable();
      self.properties = [];

      self._display = ko.observable(false);
      self._currentBranch = selector.data('next');
      self._branch = selector.data('branch');

      if(self._branch) {
        self._branch = self._branch.split('|');
        $.each(self._branch, function(branchIndex, branch) {
          self._branch[branchIndex] = branch.split(':');
          self._branch[branchIndex][0] = self._branch[branchIndex][0].split('+');

          $.each(self._branch[branchIndex][0], function(questionIndex, question) {
            self._branch[branchIndex][0][questionIndex] = question.split('=');
          });
        });
      }

      selector.children('input').each(function() {
        var binding = $(this).data('bind').split(/[,.:]/),
            property = binding[2];

        self[property] = ko.observable();
        self.properties.push(property);
      });

      self.setDisplay = ko.computed(function() {
        $.each(self.properties, function(index, prop) {
          self[prop]();
        });

        if (self._branch) {
          $.each(self._branch, function(i, branch) {
            var isBranch = true;

            $.each(branch[0], function(j, question) {
              if (self[question[0]]() != question[1]) {
                isBranch = false;
              }
            });

            if (isBranch) {
              self._previousBranch = self._currentBranch
              self._currentBranch = branch[1];
            }
          });
        }

        var currentBranch  = viewModel[self._currentBranch]  ? viewModel[self._currentBranch]()  : null;
        var previousBranch = viewModel[self._previousBranch] ? viewModel[self._previousBranch]() : null;

        if (self.isValid()) {
          if (previousBranch && previousBranch != currentBranch) {
            viewModel._erasingBranch = true;
            $.each(previousBranch.properties, function(index, prop) {
              previousBranch[prop](null);
            });
            previousBranch._display(false);
          }

          if(currentBranch) {
            currentBranch._display(true);
          }
        } else {
          console.log(self._currentBranch)
          if (viewModel._erasingBranch) {
            if (currentBranch) {
              $.each(currentBranch.properties, function(index, prop) {
                currentBranch[prop](null);
              });
              currentBranch._display(false);
            } else {
              viewModel._erasingBranch = false;
            }
          }
        }
      }).extend({ rateLimit: 50 });
    };

    var otherProps = {};

    viewModel[selector.attr('id')] = ko.validatedObservable(new section());
  })

  viewModel.section1()._display(true);

  viewModel.errors = ko.validation.group(viewModel);

  ko.applyBindings(viewModel);

});
