angular.module('carnatic.controllers')

.controller "ComposeCtrl", ['$scope', 'Auth', 'KorvaiHelper', ($scope, Auth, KorvaiHelper) ->
  $scope.createKorvai = (korvai) ->
    if korvai.content isnt ""
      Auth.user.korvais().$add korvai
      korvai.content = ""

  $scope.countMatras = (content) ->
    $scope.matras = KorvaiHelper.countMatras(content)

  $scope.korvai =
    content: "thathinkinathom,\n(thathinkinathom x2),\n(thathinkinathom x3)"
    thalam: 32
    mod: 0
]
