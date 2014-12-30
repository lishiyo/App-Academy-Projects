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

  parse: function (response) {
    if (response.feeds) {
      this.feeds().set(response.feeds, {parse: true});
      delete response.feeds;
    }

    return response;
  }
})
