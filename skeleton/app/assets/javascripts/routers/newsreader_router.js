NewsReader.Routers.FeedRouter = Backbone.Router.extend({

  routes: {
    "": "feedsIndex",
    "feeds/:id": "feedShow"
  },

  initialize: function(opts) {
    this.$rootEl = opts.$rootEl;
  },

  feedsIndex: function() {
    NewsReader.feeds.fetch();
    var feedsIndex = new NewsReader.Views.FeedsIndex({
      collection: NewsReader.feeds
    });

    this._swapView(feedsIndex);
  },

  feedShow: function(id) {
    NewsReader.feeds.fetch({
    });

    var feed = NewsReader.feeds.getOrFetch(id);
    feed.fetch();
    var feedShowView = new NewsReader.Views.FeedShow({
      model: feed
    });

    this._swapView(feedShowView);
  },

  _swapView: function(newView) {
    this._currentView && this._currentView.remove();
    this._currentView = newView;
    this.$rootEl.html(newView.render().$el);
  }

});
