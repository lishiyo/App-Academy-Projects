NewsReader.Views.FeedShow = Backbone.View.extend({
  template: JST['feeds/show'],

  tagName: 'ul',

  initialize: function(){
    this.listenTo(this.model, 'sync', this.render);
    this.subViews = []; // this.model.entries();
  },

  events: {
    "click .refresh": "refresh"
  },

  render: function() {
    var content = this.template({ feed: this.model });
    this.$el.html(content);

    var view = this;
    this.model.entries().each(function(entry){
      var subView = new NewsReader.Views.EntryShow({
        model: entry
      });
      view.subViews.push(subView);
      view.$el.append(subView.render().$el);
    });

    return this;
  },

  // unbinds all listeners from self and subviews
  leave: function(){
    this.subViews.forEach(function(subView){
      subView.leave();
    });

    this.remove();
  },

  refresh: function (event){
    event.preventDefault();
    this.model.fetch({
      success: function(){
      }.bind(this)
    });
  }
});
