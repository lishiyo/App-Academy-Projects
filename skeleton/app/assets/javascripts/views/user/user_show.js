NewsReader.Views.UserShow = Backbone.View.extend({
  template: JST['user/show'],

  initialize: function(){
    this.listenTo(this.model, 'sync', this.render);
    this.subViews = [];
  },

  render: function(){
    var content = this.template({ user: this.model });
    this.$el.html(content);

    var userView = this;
    this.model.feeds().each(function(feed){
      feed.fetch({
        success: function(){
          var subView = new NewsReader.Views.FeedShow({
            model: feed
          });

          userView.subViews.push(subView);
          userView.$el.append(subView.render().$el);
        }.bind(this)
      })

    });

    return this;
  },

  leave: function(){
    this.subViews.forEach(function(subView){
      subView.leave();
    });
    this.remove();
  }
});
