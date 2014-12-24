angular.module('carnatic', [
  'ionic'
  'firebase'
  'carnatic.controllers'
  'carnatic.factories'
  'carnatic.models'
  'carnatic.directives'
])

.run ['$ionicPlatform', '$rootScope', 'Auth', ($ionicPlatform, $rootScope, Auth) ->
  $ionicPlatform.ready ->
    if window.cordova and window.cordova.plugins.Keyboard
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true)

    if window.StatusBar
      StatusBar.styleDefault()

  $rootScope.$on '$stateChangeStart', (event, toState) ->
    if toState.name.substring(0, 3) is 'app'
      Auth.authRef.$waitForAuth().then (user) ->
        if not user?
          location.href = "/#/login"

  $rootScope.logout = ->
    Auth.logout()
    location.reload()
]

# Global values
.value('REF', new Firebase("https://carnatic.firebaseio.com/"))

# Module definitions
angular.module 'carnatic.controllers', []
angular.module 'carnatic.factories', []
angular.module 'carnatic.models', []
angular.module 'carnatic.directives', []

# Miscellaneous helpers
String.prototype.repeat = (num) ->
  new Array(num + 1).join(@)