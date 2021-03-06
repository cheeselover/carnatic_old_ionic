angular.module('carnatic.controllers')

.controller "LoginCtrl", ($scope, $state, Auth) ->
  $scope.auth = Auth
  $scope.user = $scope.auth.currentUser

  $scope.loginWithEmail = (data) ->
    Auth.loginEmail({
      email: data.email
      password: data.password
    }, { remember: "sessionOnly" })
      .then (authData) ->
        $state.go 'app.compose'
      .catch (error) ->
        alert "Authentication failed: #{error}"

  $scope.loginWithFacebook = ->
    Auth.loginOAuth('facebook', { remember: "sessionOnly" })
      .then (authData) ->
        $state.go 'app.compose'
      .catch (error) ->
        alert "Authentication failed: #{error}"

  $scope.loginWithGoogle = ->
    Auth.loginOAuth('google', { remember: "sessionOnly" })
      .then (authData) ->
        $state.go 'app.compose'
      .catch (error) ->
        alert "Authentication failed: #{error}"

  $scope.logout = ->
    $scope.auth.logout()
    location.reload()