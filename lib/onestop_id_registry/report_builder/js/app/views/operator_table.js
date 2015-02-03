var App = App || {};
App.Views = App.Views || {};

App.Views.OperatorTable = Backbone.View.extend({
  el: '#operator-table',
  initialize: function() {
     this.listenTo(this.collection, "reset sync", this.render);
  },
  rowTemplate: _.template("<tr><td><%= onestop_id %></td><td><%= name %></td></tr>"),
  render: function() {
    $('tbody', this.$el).empty();
    this.collection.each(function(operator) {
      $('tbody', this.$el).append(this.rowTemplate(operator.toJSON()));
    }, this);
  }
});
