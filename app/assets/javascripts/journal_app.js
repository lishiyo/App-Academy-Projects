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
  }
};

$(document).ready(function(){
  JournalApp.initialize();
});
