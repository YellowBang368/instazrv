# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  new ImageCropper()

class ImageCropper
  constructor: ->
    $("#cropbox").Jcrop
      aspectRatio: 1
      setSelect: [0, 0, 300, 300]
