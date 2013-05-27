var Taxonomy = {
  initialize: function() {
    Taxonomy.Nodes.Events.initialize();
  },
  containerElement: ".js_tree_diagrams"
}

Taxonomy.Nodes = {}
Taxonomy.Nodes.Events = {
  initialize: function() {
    this.mouseOver();
    this.newNodeForm();
    this.editNodeForm();
  },

  mouseOver: function() {
    $(Taxonomy.containerElement).on("mouseover", ".box.name", function(e) {
      var node = new Taxonomy.Node(e.target);
      Taxonomy.NodesOptions.hideAllNodes();
      node.showOptions();

      e.stopPropagation();
    });
  },
  newNodeForm: function() {
    $(Taxonomy.containerElement).on("click", "#show_new_node_form", function(e) {
      var node = new Taxonomy.Node(e.target);
      node.showNewForm();

      e.stopPropagation();
      return false;
    });
  },
  editNodeForm: function() {
    $(Taxonomy.containerElement).on("click", "#show_edit_node_form", function(e) {
      var node = new Taxonomy.Node(e.target);
      node.showEditForm();

      e.stopPropagation();
      return false;
    });
  }
}

Taxonomy.NodesOptions = {
  hideAllNodes: function() {
    $(".js_tree_body .node_options").hide();
  }
}

Taxonomy.Node = function(node) {
  this.node     = node;
  this.element  = function() { return $(node).closest(".node"); }
  this.text     = function() { return this.element().find(".box").text(); }
  this.options  = function() { return new Taxonomy.Node.Options(this); }
  this.newForm  = function() { return new Taxonomy.Node.NewForm(this); }
  this.editForm = function() { return new Taxonomy.Node.EditForm(this); }

  this.showOptions = function() {
    this.options().show();
  }

  this.showNewForm = function() {
    this.newForm().show();
  }

  this.showEditForm = function() {
    this.editForm().show();
  }
}

Taxonomy.Node.Options = function(node) {
  this.node = node;
  this.element = function() { return this.node.element().find(".node_options"); }

  this.show = function() {
    this.element().show();
  }
}

Taxonomy.Node.NewForm = function(node) {
  this.node = node;
  this.element = function() { return this.node.element().find(".js_new_node_form"); }

  this.show = function() {
    this.element().show();
  }
}

Taxonomy.Node.EditForm = function(node) {
  this.node = node;
  this.element = function() { return this.node.element().find(".js_edit_node_form"); }

  this.show = function() {
    this.element().show();
  }
}

$(document).ready(function() {
  Taxonomy.initialize();
});
