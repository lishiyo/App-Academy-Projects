JournalApp.Collections.Posts = Backbone.Collection.extend({
  url: '/posts', //posts#index
  model: JournalApp.Models.Post
});
