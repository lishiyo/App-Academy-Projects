window.JournalApp = {
  Models: {},
  Collections: {},
  Views: {},
  Router: {},
  initialize: function() {
    console.log('Hello from Backbone!');

    JournalApp.posts = new JournalApp.Collections.Posts();
    // creates a model, calls model.save(), then collection.add(model)
    // JournalApp.posts.create({
    //   title: "My First Post",
    //   body: "Hello from App Academy!"
    // });

    var $main = $("#main_content"),
        $sidebar = $("div#sidebar");

    JournalApp.posts.fetch({
      success: function(){
        var postsIndex = new JournalApp.Views.PostsIndex({
          collection: JournalApp.posts
        });
        $sidebar.html(postsIndex.render().$el);

        new JournalApp.Router.PostsRouter({ $rootEl: $main });

        Backbone.history.start();
      }
    });



    // JournalApp.posts.fetch({
    //   success: function(){
    //     console.log("Fetch succeeded!");
    //     var postIndexView = new JournalApp.Views.PostsIndex({collection: JournalApp.posts});
    //     $main.html(postIndexView.render().$el);
    //     }
    // });


  }
};

$(document).ready(function(){
  JournalApp.initialize();
});
