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
//= require jquery.ui.effect.all
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

app.directive('ngDisplay', function() {
  return function(scope, element, attrs) {
    scope.$watch(attrs.ngDisplay, function(display) {
      if(display) {
        element.removeClass('ng-hide');
        if(scope.transitionDirection == 'prev') {
          element.css('opacity', 0);
          element.css('left','-50%');
          jQuery(element).animate({
            opacity: 1,
            left: 0
          }, {
            easing: 'easeInOutCirc'
          });
        } else {
          element.css('opacity', 0);
          element.css('left','50%');
          jQuery(element).animate({
            opacity: 1,
            left: 0
          }, {
            easing: 'easeInOutCirc',
          });
        }
      } else {
        if(scope.transitionDirection == 'prev') {
          element.css('opacity',1);
          element.css('left', 0);
          jQuery(element).animate({
            opacity:0,
            left: '50%'
          }, {
            easing: 'easeInOutCirc',
            complete: function() {
              element.addClass('ng-hide');
            }
          });
        } else {
          element.css('opacity',1);
          element.css('left',0);
          jQuery(element).animate({
            opacity:0,
            left: '-50%'
          }, {
            easing: 'easeInOutCirc',
            complete: function() {
              element.addClass('ng-hide');
            }
          });
        }
      }
    })
  }
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
