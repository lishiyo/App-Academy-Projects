window.JournalApp = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  initialize: function() {
    console.log('Hello from Backbone!');

    JournalApp.posts = new JournalApp.Collections.Posts();
    // creates a model, calls model.save(), then collection.add(model)
    JournalApp.posts.create({
      title: "My First Post",
      body: "Hello from App Academy!"
    });

    var $main = $("#main_content");

    JournalApp.posts.fetch({
      success: function(){
        console.log("Fetch succeeded!");
        var postIndexView = new JournalApp.Views.PostsIndex({collection: JournalApp.posts});
        $main.html(postIndexView.render().$el);
        }

    });
  }
};

$(document).ready(function(){
  JournalApp.initialize();
});
