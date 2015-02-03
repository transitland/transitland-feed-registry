var App = App || {};
App.Entities = App.Entities || {};

App.Entities.Feed = Backbone.Model.extend();

App.Entities.Feeds = Backbone.Collection.extend({
  url: '/json/feeds.json',
  model: App.Entities.Feed
});
