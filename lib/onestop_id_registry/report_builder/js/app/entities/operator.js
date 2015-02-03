var App = App || {};
App.Entities = App.Entities || {};

App.Entities.Operator = Backbone.Model.extend();

App.Entities.Operators = Backbone.Collection.extend({
  url: '/json/operators.json',
  model: App.Entities.Operator
});
