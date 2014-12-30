window.NewsReader = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  initialize: function() {
    NewsReader.feeds = new NewsReader.Collections.Feeds();
    var $content = $('div#content');

    new NewsReader.Routers.FeedRouter({
      $rootEl: $content
    });
    Backbone.history.start();
  }
};

$(document).ready(function(){
  NewsReader.initialize();
});
