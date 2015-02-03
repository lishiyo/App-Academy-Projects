NewsReader.Views.FeedsIndex = Backbone.View.extend({
  template: JST['feeds/index'],

  events: {
    "click .delete": "delete",
    "click .favorite": 'favoriteFeed'
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
  },

  favoriteFeed: function(e){
    e.preventDefault();
    var btn = $(e.currentTarget);
    var feedId = btn.data("id");
    var url = "/api/feeds/" + feedId + "/favorite";
    $.ajax({
      type: "POST",
      url: url,
      success: function(data){
        console.log(data);
        btn.remove();
        Backbone.history.navigate("#/users/"+ data.user_id, {trigger: true});
      },
      error: function(resp){
        console.log(resp);
      }
    });
  }

});
