NewsReader.Models.User = Backbone.Model.extend({
  urlRoot: "api/users",

  toJSON: function() { // nest everything under user
    return { user: this.attributes }
  },

  feeds: function () {
    if (!this._feeds) {
      this._feeds = new NewsReader.Collections.Feeds([], {user: this});
    };

    return this._feeds;
  },

  favorited_feeds: function(){
    if (!this._favorited_feeds) {
      this._favorited_feeds = new NewsReader.Collections.Feeds([], {user: this});
    }

    return this._favorited_feeds
  },

  parse: function (response) {
    if (response.feeds) {
      this.feeds().set(response.feeds, {parse: true});
      delete response.feeds;
    }

    if (response.favorited_feeds) {
      this.favorited_feeds().set(response.favorited_feeds, {parse: true});
      delete response.favorited_feeds;
    }

    return response;
  }
})
