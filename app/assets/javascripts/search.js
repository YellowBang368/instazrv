$(document).ready(function() {
  $input = $("#searchBox");


  var options = {
    getValue: "username",
    url: function(phrase) {
      return "/search.json?q=" + phrase
    },
    categories: [
      {
        listLocation: "users",
        header: "<strong>users</strong>"
      }
    ],
    list: {
      onChooseEvent: function() {
        var url = $input.getSelectedItemData().url
        window.location.replace(url);
      }
    }
  };

  $input.easyAutocomplete(options)
})
