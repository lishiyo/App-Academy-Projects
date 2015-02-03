NewsReader.Views.UserShow = Backbone.View.extend({
  template: JST['user/show'],

  initialize: function(){
    this.listenTo(this.model, 'sync', this.render);
    this.subViews = [];
  },

  render: function(){

    var $allFeeds = $('<div></div>').addClass("allFeeds");
    var $favFeeds = $('<div></div>').addClass("favFeeds");
    $allFeeds.empty();
    $favFeeds.empty();
    this.subViews = [];

    var content = this.template({ user: this.model });
    this.$el.html(content);

    var userView = this;
    this.model.feeds().each(function(feed){
      feed.fetch();
      var subView = new NewsReader.Views.FeedShow({
        model: feed
      });

      userView.subViews.push(subView);

      $allFeeds.append(subView.render().$el);
      userView.$el.append($allFeeds);

    });

    this.model.favorited_feeds().each(function(feed){
      feed.fetch();

      var subView = new NewsReader.Views.FeedShow({
        model: feed
      });
      console.log(feed);

      userView.subViews.push(subView);

      console.log(userView.subViews);


      $favFeeds.append(subView.render().$el);
      userView.$el.prepend($favFeeds);
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
