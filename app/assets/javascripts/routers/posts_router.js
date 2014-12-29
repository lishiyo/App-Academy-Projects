JournalApp.Router.PostsRouter = Backbone.Router.extend({

  routes: {
    "": "postsIndex",
    "posts/new": "postNew",
    "posts/:id": "postShow",
    "posts/:id/edit": "postEdit"
  },

  initialize: function(options){
    this.$rootEl = options.$rootEl;
  },

  postsIndex: function(){
    console.log("Get to post index")
    var posts = JournalApp.posts;
    posts.fetch({
      success: function(){
        var postIndexView = new JournalApp.Views.PostsIndex({collection: posts});
        this._swapView(postIndexView);
      }.bind(this)
    })
  },

  postShow: function(id) {
    var post = JournalApp.posts.getOrFetch(id);
    post.fetch({
      success: function(){
        var postShowView = new JournalApp.Views.PostShow({model: post});
        this._swapView(postShowView);
      }.bind(this)
    });
  },

  postNew: function() {

    var post = new JournalApp.Models.Post();
    var postNewView = new JournalApp.Views.PostForm({
      model: post,
      collection: JournalApp.posts
    });
    this._swapView(postNewView);
  },

  postEdit: function(id) {
    var post = JournalApp.posts.getOrFetch(id);
    post.fetch({
      success: function(){
        var postEditView = new JournalApp.Views.PostForm({model: post});
        this._swapView(postEditView);
      }.bind(this)
    });
  },

  _swapView: function (newView) {
    this._currentView && this._currentView.remove();
    this._currentView = newView;
    this.$rootEl.html(newView.render().$el);
  }

});

// JournalApp.posts.fetch({
//   success: function(){
//     console.log("Fetch succeeded!");
//     var postIndexView = new JournalApp.Views.PostsIndex({collection: JournalApp.posts});
//     $main.html(postIndexView.render().$el);
//     }
// });
