NewsReader.Routers.FeedRouter = Backbone.Router.extend({

  routes: {
    "": "feedsIndex",
    "feeds/new": "feedNew",
    "feeds/:id": "feedShow",
    "users/new": "userNew",
    "session/new": "sessionNew",
    "users/:id": "userShow"
  },

  initialize: function(opts) {
    this.$rootEl = opts.$rootEl;
  },

  feedsIndex: function() {
    var feedsForm = $("<div>").addClass("new-feed-form");

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
  },

  feedNew: function () {
    var newFeed = new NewsReader.Models.Feed();
    var feedNewView = new NewsReader.Views.FeedNew({ model: newFeed });

    this._swapView(feedNewView);
  },

  userNew: function (){
    var newUser = new NewsReader.Models.User();
    var userNewView = new NewsReader.Views.UserNew({ model: newUser });

    this._swapView(userNewView);
  },

  sessionNew: function(){
    var newUser = new NewsReader.Models.User();
    var sessionNewView = new NewsReader.Views.SessionNew({ model: newUser });

    this._swapView(sessionNewView);
  },

  userShow: function(id){
    var user = new NewsReader.Models.User({id: id});

    user.fetch({
      success: function (){
        var userShowView = new NewsReader.Views.UserShow({ model: user });
        this._swapView(userShowView);
      }.bind(this)
    });
  }
});
