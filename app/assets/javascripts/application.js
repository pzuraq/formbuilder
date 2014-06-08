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

app.animation('.section', ['$rootScope', function($rootScope) {
  return {
    beforeAddClass : function(element, className, done) {
      if(className == 'ng-hide') {
        var offset = ($rootScope.transitionDirection == 'prev') ? '50%' : '-50%';

        element.css({
          opacity: 1,
          left: 0
        }).animate({
          opacity: 0,
          left: offset
        }, {
          easing: 'easeInOutCirc',
          done: done
        });
      } else {
        done();
      }
    },
    removeClass : function(element, className, done) {
      if(className == 'ng-hide') {
        var offset = ($rootScope.transitionDirection == 'prev') ? '-50%' : '50%';

        element.find('.btn-next, .btn-prev').css({
          'max-height': element.height() + 138 + 'px'
        });

        element.css({
          opacity: 0,
          left: offset
        }).animate({
          opacity: 1,
          left: 0
        }, {
          easing: 'easeInOutCirc',
          done: done
        });
      } else {
        done();
      }
    }
  }
}]);

app.animation('.btn', ['$rootScope', function($scope) {
  return {
    beforeAddClass : function(element, className, done) {
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
}]);

app.animation('.followup', ['$rootScope', function($scope) {
  return {
    beforeAddClass : function(element, className, done) {
      if(className == 'ng-hide') {
        element.parent('.section').find('.btn-next, .btn-prev').css({
          'max-height': element.parent('.section').height() + 138 + 'px'
        });

        $.when.apply($, [element.animate({ opacity:0 }), element.slideUp({ queue: false })]).done(function() {
          element.parent('.section').find('.btn-next, .btn-prev').css({
            'max-height': element.parent('.section').height() + 138 + 'px'
          });

          done();
        });
      } else {
        done();
      }
    },
    removeClass : function(element, className, done) {
      if(className == 'ng-hide') {
        element.css({
          opacity: 0,
          display: 'none'
        });

        $.when.apply($, [element.animate({ opacity:1 }), element.slideDown({ queue: false })]).done(function() {
          element.parent('.section').find('.btn-next, .btn-prev').css({
            'max-height': element.parent('.section').height() + 138 + 'px'
          });

          done();
        });
      } else {
        done();
      }
    }
  };
}]);

app.directive('ngConditional', function() {
  return function(scope, element, attr) {
    scope.$watch(attr.ngConditional, function(value) {
      scope[attr.name].conditional = value;
    });
  }
});

app.controller('formbuilder', function($scope, $rootScope) {
  $scope.init = function() {
    if ($scope.section0) {
      $scope.section0.$show = true
    }
  };

	$scope.next = function(num) {
		$rootScope.transitionDirection = 'next';

    var current = num, next = num + 1;

    while($scope['section'+next] && !$scope['section'+next].conditional) {
      next += 1;
    }

		$scope['section'+next].$show = true;
		$scope['section'+current].$show = false;
	};

	$scope.prev = function(num) {
		$rootScope.transitionDirection = 'prev';

    var current = num, prev = num - 1;

    while($scope['section'+prev] && !$scope['section'+prev].conditional) {
      prev -= 1;
    }

		$scope['section'+prev].$show = true;
		$scope['section'+current].$show = false;
	};

	$scope.open = function($event) {
    $event.preventDefault();
    $event.stopPropagation();

    $scope.opened = true;
  };
});

$(document).on('page:change', function () {
	$('#edit').click(function() {
		$('.lock').addClass('hide');
		$('.edit').removeClass('hide');
	});

	$('#edit-cancel').click(function() {
		$('.lock').removeClass('hide');
		$('.edit').addClass('hide');
	});
});

$(document).on('page:load', function() {
  $('[ng-app]').each(function() {
    module = $(this).attr('ng-app');
    console.log(module);
    angular.bootstrap(this, [module]);
  });
});
