/* single-page app initialization */
$(document).ready(function() {

  var appLayoutView = new App.Views.AppLayoutView();
  appLayoutView.render();

  var operators = new App.Entities.Operators();
  var feeds = new App.Entities.Feeds();

  var operatorTable = new App.Views.OperatorTable({
    collection: operators
  });
  var feedTableView = new App.Views.FeedTableView({
    collection: feeds
  });

  appLayoutView.getRegion("main").show(feedTableView)

  operators.fetch();
  feeds.fetch();
});
