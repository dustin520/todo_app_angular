# Define app and dependencies
TodoApp = angular.module("TodoApp", ["ngRoute", "templates"])

# Setup angular router
TodoApp.config ["$routeProvider", "$locationProvider", ($routeProvider, $locationProvider) ->
  $routeProvider
    .when '/',
      templateUrl: "index.html",
      controller: "TodosCtrl"
  .otherwise
    redirectTo: "/"

  $locationProvider.html5Mode(true)
] # close todoapp config 

# Todos Controller
TodoApp.controller "TodosCtrl", ["$scope", "$http", ($scope, $http) ->
  $scope.todos = []

  # READ
  $scope.getTodos = () ->
    # make a GET req to /todos.json
    $http.get("/todos.json").success (data) -> 
      $scope.todos = data

  $scope.getTodos()

  # CREATE
  $scope.addTodo = ->
    $http.post("/todos.json", $scope.newTask).success (data) -> 
      $scope.newTask = {}
      $scope.todos.push(data)

  # DELETE
  $scope.deleteTodo = (todo) ->
    conf = confirm "Are you sure?"
    if conf
      $http.delete("/todos/#{todo.id}.json").success (data) ->
        $scope.todos.splice($scope.todos.indexOf(todo),1)

  # EDIT
  $scope.editTodo = (todo) ->
    this.checked = false
    $http.put("/todos/#{this.todo.id}.json", todo).success (data) ->


] # close todos controller


# Define Config for CSRF token
TodoApp.config ["$httpProvider", ($httpProvider)->
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
]