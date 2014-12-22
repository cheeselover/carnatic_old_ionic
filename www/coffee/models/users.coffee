angular.module('carnatic.models')

.factory "User", ['$firebase', 'KorvaiList', 'UserProfile', ($firebase, KorvaiList, UserProfile) ->
  class User
    constructor: (@userId) ->
    userProfile: ->
      new UserProfile(@userId)
    korvais: ->
      new KorvaiList(@userId)
]