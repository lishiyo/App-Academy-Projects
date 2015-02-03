NewsReader.Views.FeedNew = Backbone.View.extend({
  template: JST['feeds/new'],

  events: {
    "submit form": "createFeed"
  },

  render: function (){
    var content = this.template({ feed: this.model });
    this.$el.html(content);
    return this;
  },

  createFeed: function (event){
    event.preventDefault();
    var formData = $(event.currentTarget).serializeJSON().feed;

    this.model.save(formData, {
      success: function() {
        NewsReader.feeds.add(this.model);
        console.log(this.model);
        Backbone.history.navigate("", {trigger: true});
      }.bind(this)
    });

  }
})
