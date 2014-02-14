if (!Admin) { var Admin = {}; }

/**
  This depends on Admin.FieldSearch.
 */
$(document).ready(function(){
  var customFields = new Admin.CustomFields({
    selector: ".js_custom_field",
    dependsOn: "#inventory_item_taxonomy_id",
    matchingRecord: "for-categories",
  });
});

Admin.CustomFields = function(options) {
  this.options = options;

  var currentReferenceValue = $(options.dependsOn).val();

  this.observeChange = function(selector) {
    Admin.FieldSearch.observe(selector, this.updateFields);
  }

  this.updateFields = function(value) {
    $(options.selector).each(function() {
      value = ""+value;

      console.log(options);
      console.log(options.matchingRecord);
      console.log(element.data(options.matchingRecord).split(","));
      var element = $(this),
          parentDiv = element.closest("div.input"),
          visibleRecords = element.data(options.matchingRecord).split(","),
          showForAll = !visibleRecords[0].length,
          isMatch = $.inArray(value, visibleRecords) >= 0;

      if (showForAll || isMatch) {
        parentDiv.show();
        parentDiv.find(":input").prop("disabled", false);
      } else {
        parentDiv.hide();
        parentDiv.find(":input").prop("disabled", true);
      }
    });
  }

  this.observeChange(this.options.dependsOn);
  this.updateFields(currentReferenceValue);

  return this;
}
