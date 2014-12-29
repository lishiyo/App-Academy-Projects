JournalApp.Models.Post = Backbone.Model.extend({
  urlRoot: 'posts/',

  validate: function(attrs) {
    if (!attrs.title) {
      // return 'please fill title field'
    }
  }
});
