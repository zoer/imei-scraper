ImeiFactory = ($resource) ->
  Imei = $resource "/search/:imei.json", {imei: @imei}

  Imei

@App.factory('Imei', ['$resource', ImeiFactory])
