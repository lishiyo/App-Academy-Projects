NewsReader.Views.FeedsIndex = Backbone.View.extend({
  template: JST['feeds/index'],

  events: {
    "click .delete": "delete"
  },

  initialize: function(){
    this.listenTo(this.collection, "sync remove", this.render);
  },

  render: function(){
    var content = this.template({feeds: this.collection});
    this.$el.html(content);
    return this;
  },

  delete: function(event) {
    event.preventDefault();
    var feedId = $(event.currentTarget).data("id");
    var feed = this.collection.get(feedId);
    feed.destroy();

  }
});
