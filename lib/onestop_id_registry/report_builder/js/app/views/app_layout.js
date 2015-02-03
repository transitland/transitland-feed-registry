var App = App || {};
App.Views = App.Views || {};

App.Views.AppLayoutView = Marionette.LayoutView.extend({
  el: 'body',
  template: "#app-layout-view-template",
  regions: {
    topBar: "#top-bar",
    leftBar: "#left-bar",
    main: "#main"
  },
  onBeforeShow: function() {
    debugger
    this.getRegion("topBar").show(new App.Views.TopBarView());
    this.getRegion("leftBar").show(new App.Views.LeftBarView());
  }
});
