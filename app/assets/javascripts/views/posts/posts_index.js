JournalApp.Views.PostsIndex = Backbone.View.extend({

  template: JST["posts/index"],

  events: {
    "click .deleteBtn" : "deletePost"
  },

  initialize: function() {
    this.listenTo(this.collection, 'remove add change:title reset', this.render);
  },

  render: function(){
    var content = this.template({posts: this.collection});
    this.$el.html(content);
    return this;
  },

  deletePost: function(event){
    var postId = $(event.currentTarget).data("id");
    var post = this.collection.get(postId);
    console.log(post);
    post.destroy();
  }

});
