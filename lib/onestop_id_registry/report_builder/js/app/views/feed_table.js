var App = App || {};
App.Views = App.Views || {};

App.Views.FeedTableRowView = Marionette.ItemView.extend({
  template: "#feed-table-row-template",
  tagName: "tr"
});

App.Views.FeedTableView = Marionette.CompositeView.extend({
  initialize: function() {
     this.listenTo(this.collection, "reset sync", this.render);
  },
  template: "#feed-table-template",
  childViewContainer: "tbody",
  childView: App.Views.FeedTableRowView
});
