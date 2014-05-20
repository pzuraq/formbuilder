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
//= require bootstrap
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

ko.validatedObservable = function (initialValue) {
	if (!ko.validation.utils.isObject(initialValue)) { return ko.observable(initialValue).extend({ validatable: true }); }

	var obsv = ko.observable(initialValue);
	obsv.errors = ko.validation.group(initialValue);
	obsv.isValid = ko.computed(function () {
		if (obsv().required) {
			return obsv().required() ? obsv.errors().length === 0 : true;
		} else {
			return obsv.errors().length === 0;
		}
	});

	return obsv;
};

ko.bindingHandlers.fadeVisible = {
  init: function(element, valueAccessor) {
    // Initially set the element to be instantly visible/hidden depending on the value
    var value = ko.unwrap(valueAccessor());
    $(element).toggle(value); // Use "unwrapObservable" so we can handle values that may or may not be observable
  },
  update: function(element, valueAccessor) {
    // Whenever the value subsequently changes, slowly fade the element in or out
    var value = ko.unwrap(valueAccessor());
    value ? $('div').promise().then(function() {
       $(element).fadeIn()
    }) : $(element).fadeOut();
  }
};

var viewModel = {}

function branch(parent, selector) {
	var self = this;

	self.parent = parent;
	self.required = ko.observable(false);
	self.branchConditions = selector.data('branch').split('+');
	self.display = ko.observable(false);
	self.sections = [];

	for (condition in self.branchConditions) {
		self.branchConditions[condition] = self.branchConditions[condition].split('=');
	}

	selector.children('.section').each(function(index) {
		var sectionName = $(this).attr('id');

		self[sectionName] = ko.validatedObservable(new section(index, self, $(this)));
		self.sections.push(sectionName);
	});

	self.setRequired = ko.computed(function() {
		var isRequired = true;

		for (condition in self.branchConditions) {
			var question = self.branchConditions[condition][0],
					answer   = self.branchConditions[condition][1];

			isRequired = isRequired && self.parent[question]() == answer;
		}

		self.required(isRequired);
	});

	self.clearBranch = ko.computed(function() {
		if (!self.required()) {
			for (sectionName in self.sections) {
				self[self.sections[sectionName]]().clearProperties();
			}
		}
	});
}

function section(index, parent, selector) {
	var self = this;

	self.parent = parent;
	self.isValid = ko.observable();
	self.properties = [];
	self.index = index;
	self.display = self.index == 0 ? ko.observable(true) : ko.observable(false);

	selector.children('.form-group').find('input').each(function() {
		var property = $(this).attr('name').replace(/ans\[|\]/g,''),
		    validations = $(this).data('validations');

		console.log(property)

		if(!self[property]) {
			self[property] = ko.observable();

			if (validations.required) {
				self[property].extend({ required: true });
			}

			self.properties.push(property);
		}
	});

	selector.children('.branch').each(function() {
		var branchName = $(this).attr('id');

		self[branchName] = ko.validatedObservable(new branch(self, $(this)));
	});

	self.setDisplay = ko.computed(function() {
		$.each(self.properties, function(index, prop) {
			self[prop]();
		});

		var next = parent['s'+(index+1)];

		if (next) {
			if (self.isValid()) {
				next().display(true);
			} else {
				next().display(false);
			}
		}
	}).extend({ rateLimit: 50 });

	self.clearProperties = function() {
		for (property in self.properties) {
			self[self.properties[property]](null);
		}
	}
}


$(function () {
  $('.form').children('.section').each(function(index) {
    viewModel[$(this).attr('id')] = ko.validatedObservable(new section(index, viewModel, $(this)));
  })

  ko.applyBindings(viewModel);
});
