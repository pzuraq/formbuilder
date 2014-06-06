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
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap
//= require pickadate/picker
//= require pickadate/picker.date
//= require pickadate/picker.time
//= require angular
//= require angular-animate
//= require angular-ui-bootstrap-tpls
//= require angular_better_placeholders
//= require ng-pickadate
//= require_tree .

app = angular.module('formbuilder', ['ngAnimate', 'ui.bootstrap', 'angularBetterPlaceholder', 'ng.pickadate'])

app.animation('.section', function() {
  return {
    addClass : function(element, className, done) {
      if(className == 'ng-hide') {
        jQuery(element).animate({
          opacity:0
        }, done);
      }
      else {
        done();
      }
    },
    removeClass : function(element, className, done) {
      if(className == 'ng-hide') {
        element.css('opacity',0);
        jQuery(element).animate({
          opacity:1
        }, done);
      }
      else {
        done();
      }
    }
  };
});

function Controller($scope) {
  $scope.init = function() {
		if ($scope.section0) {
			$scope.section0.$show = true
		}
	}

	$scope.next = function(num) {
		$scope.transitionDirection = 'next';
		$scope['section'+(num+1)].$show = true;
		$scope['section'+num].$show = false;
	}

	$scope.prev = function(num) {
		$scope.transitionDirection = 'prev';
		$scope['section'+(num-1)].$show = true;
		$scope['section'+num].$show = false;
	}

	$scope.open = function($event) {
    $event.preventDefault();
    $event.stopPropagation();

    $scope.opened = true;
  };

	$scope.question1 = null;
}
