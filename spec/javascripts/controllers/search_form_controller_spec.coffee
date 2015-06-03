#= require spec_helper

describe "Controller: SearchFormController", ->
  beforeEach ->
     @controller("SearchFormController", { $scope: @scope })

  it "#isIMEIValid", ->
   expect(@scope.isIMEIValid("123456789012347")).toBe(true)
   expect(@scope.isIMEIValid("013977000323877")).toBe(true)
   expect(@scope.isIMEIValid("013896000639712")).toBe(true)
   expect(@scope.isIMEIValid("123456789012348")).toBe(false)
   expect(@scope.isIMEIValid("12345678901234")).toBe(false)
   expect(@scope.isIMEIValid("1234567890123477")).toBe(false)
