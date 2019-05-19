# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  new ImageCropper()

class ImageCropper
  constructor: ->
    $("#cropbox").Jcrop
      aspectRatio: 1
      setSelect: [0, 0, 600, 600]
      onSelect: @update
      onChange: @update

  update: (coords) =>
    $("#post_crop_x").val(coords.x)
    $("#post_crop_y").val(coords.y)
    $("#post_crop_w").val(coords.w)
    $("#post_crop_h").val(coords.h)
