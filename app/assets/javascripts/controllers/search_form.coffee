#
# SearchController controls the search and display the IMEI results.
#
SearchFormController = ($scope, $timeout, Imei) ->
  $scope.imei = ""
  $scope.showInvalidBadge = false
  $scope.loading = false

  $scope.imeiInfo = null
  $scope.imeiInfoImage = null

  #
  # Search the info by given IMEI
  #
  $scope.search = ()->
    $scope.loading = true

    Imei.get imei: $scope.imei, (i)->
      $scope.imeiInfo = JSON.stringify(i, null, 2)
      if i.result?.image?
        $scope.imeiInfoImage = i.result.image
      else
        $scope.imeiInfoImage = null

      $scope.loading = false
  #
  # Validate IMEI on the input change
  #
  $scope.validateIMEI = ()->
    $timeout ( ->
      $scope.showInvalidBadge =
        $scope.imei.length > 0 && !$scope.isIMEIValid($scope.imei)
    ), 500

  #
  # Is given number is a valid IMEI
  #
  # @params {String} imei IMEI number
  #
  # @return {Boolean} returns result of IMEI validation
  #
  $scope.isIMEIValid = (imei)->
    return false if !/^[0-9]{15}$/.test(imei)
    sum = 0
    factor = 2
    i = 13
    li = 0
    while i >= li
      multipliedDigit = parseInt(imei.charAt(i), 10) * factor
      sum += if multipliedDigit >= 10 then \
        multipliedDigit % 10 + 1 else multipliedDigit
      if factor == 1 then factor++ else factor--
      i--
    checkDigit = (10 - (sum % 10)) % 10
    !(checkDigit != parseInt(imei.charAt(14), 10))

  #
  # Key press handler
  #
  $scope.onKeyPress = (event)->
    if event.which == 13
      $scope.search()

@App.controller('SearchFormController', ['$scope', '$timeout', "Imei", SearchFormController])
