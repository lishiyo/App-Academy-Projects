JournalApp.Collections.Posts = Backbone.Collection.extend({
  url: '/posts', //posts#index
  model: JournalApp.Models.Post,

  getOrFetch: function(id){
    var post = JournalApp.posts.get(id);
    if (post){
      post.fetch();
    } else { // post is not in collection
      post = new JournalApp.Models.Post({id: id}); // hits posts#show
      post.fetch({
        success:function(){
          this.add(post);
        }.bind(this)
      });
    }

    return post;
  }
});
