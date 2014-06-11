/*
 * angular-pickadate-directive v0.0.1
 * (c) 2014 Terru Huang http://blog.lifetaiwan.net
 * License: MIT
 */

'use strict';

angular.module('ng.pickadate', []).
  directive('pickADate', [ '$parse',function($parse){
    return {
      restrict: 'A',
      link: function(scope, element, attrs) {
        var ngModel = $parse(attrs.ngModel);
        element.pickadate({
          format: 'mm/dd/yyyy',
          max: true,
          selectYears: 100,
          selectMonths: true,
          onSet: function(e){
            ngModel.assign(scope, this.get());
          }
        });
      }
    };

}]).
  directive('pickATime', [ '$parse', function($parse){
    return {
      restrict: 'A',
      link: function(scope, element, attrs) {
        var ngModel = $parse(attrs.ngModel);
        element.pickatime({
          onSet: function(e){
            ngModel.assign(scope, this.get());
          }

        });
      }
    };

}]);
