$(document).ready(function() {

  if ($("[name='search']").length) {
    $("[name='search']").each(function() {
      var search = new Search.Input(this);
      search.setBindings();
    });
  }

});

var Search = {}
Search.Input = function(searchInput) {

  this.constructor = function(searchInput) {
    this.searchInput = $(searchInput);
    this.searchTimer = null;
  }

  this.domElement = function() { return this.searchInput }

  this.setBindings = function() {
    var that = this;

    this.searchInput.on('keyup', function() {
      var query = $(this).val(),
          url   = $(this).data('url');
      clearTimeout(that.searchTimer);

      if (query == "")
        that.domElement().html("");
      else {
        that.searchTimer = setTimeout(function() {
          var request = new Search.Request(query, url, that);
          request.request();
        }, 300);
      }
    });
  }

  this.constructor(searchInput);
  return this;
}

Search.Request = function(query, url, input) {
  this.constructor = function(query, url, input) {
    this.query = query;
    this.url   = url;
    this.input = input;
  }

  this.elementToUpdate = function() {
    return $( $(input.domElement()).data('results') );
  }

  this.request = function() {
    var request = this,
        query = this.query,
        url = this.url;

    $.ajax({
      url: url,
      data: { search: query },
      dataType: "json",
      complete: function(response) {
        var json            = $.parseJSON(response.responseText),
            responseProcess = new Search.Response(json, request);

        responseProcess.process();
      }
    });
  }

  this.constructor(query, url, input);
  return this
}

Search.Response = function(json, request) {
  this.request = null;
  this.json    = null;

  this.constructor = function(json, request) {
    this.request = request;
    this.json    = json;
  }

  this.process = function() {
    var resultsArray,
        resultHtml,
        json = this.json;

    for(key in json) { resultsArray = json[key]; }

    resultHtml = "<ul>";
    for(index in resultsArray) {
      var currentResult = resultsArray[index],
          url = this.showUrlPrefix() + "/" + currentResult.id;

      resultHtml+= "<li>";
      resultHtml+= "<a href='"+url+"'>";
      resultHtml+= currentResult.name;
      resultHtml+= "</a>";
      resultHtml+= "</li>";
    }
    resultHtml+= "</ul>";

    this.updateResult(resultHtml);
  }

  this.elementToUpdate = function() {
    return this.request.elementToUpdate();
  }

  this.showUrlPrefix = function() {
    return this.elementToUpdate().data("show-url-prefix");
  }

  this.updateResult = function(results) {
    this.elementToUpdate().html(results);
  }

  this.constructor(json, request);
  return this;
}
